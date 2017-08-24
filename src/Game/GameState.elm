module Game.GameState exposing (GameState, newGame, tickUpdate, build, gather, canBuild, canResearch, research)

import Time exposing (Time, inSeconds)
import EveryDict exposing (..)
import Maybe exposing (..)

import Game.Resources exposing (Resource)
import Game.Objects exposing (..)
import Game.Science exposing(initialTechnos, technoInfo)
import Game.Buildings exposing (baseProd, baseCost, entropyCost, initialBuildings)
import Game.Entropy exposing (prodMult)

type alias GameState =
    { lastUpdate: Time
    , storage: EveryDict Resource Float
    , buildings: EveryDict Building Int
    , technologies: EveryDict Technology TechnologyState
    , level: Level
    , entropy: Float
    , maxEntropy: Float
    }

newGame: GameState
newGame =
    { lastUpdate = 0.0
    , storage = empty
    , buildings = EveryDict.fromList (initialBuildings |> List.map (\b -> (b, 0)))
    , technologies = EveryDict.fromList (initialTechnos |> List.map (\t -> (t, Unlocked)))
    , level = initialLevel
    , entropy = 0.0
    , maxEntropy = 1000.0
    }

-- Gathering
gather: GameState -> Resource -> GameState
gather gs resource =
    let
        entropyRatio = prodMult gs.entropy gs.maxEntropy
    in
        { gs | storage = gs.storage |> EveryDict.update resource (\val -> Just (entropyRatio + (withDefault 0.0 val))) }

-- Building actions

canBuild: GameState -> Building -> Bool
canBuild gs b =
    baseCost b
        |> List.map (\(resource, amount) -> (EveryDict.get resource gs.storage |> withDefault 0.0) >= amount)
        |> List.foldr (\l r -> l && r) True

build: GameState -> Building -> GameState
build gs building =
    if (canBuild gs building) then {
        gs | buildings = EveryDict.update building (\count -> Just (1 + (withDefault 0 count))) gs.buildings
           , storage = consume gs.storage (baseCost building)
           , entropy = gs.entropy + (entropyCost building)
    } else gs

consume: EveryDict Resource Float -> List (Resource, Float) -> EveryDict Resource Float
consume storage cost =
    cost |> List.foldr (\(resource, cost) store ->
                    store |> EveryDict.update resource (\val ->
                        val |> Maybe.map (\v -> v - cost)
                    )
                  ) storage

-- Research Actions

canResearch: GameState -> Technology -> Bool
canResearch gs t =
    let info = technoInfo t in
    info.cost
        |> List.map (\(resource, amount) -> (EveryDict.get resource gs.storage |> withDefault 0.0) >= amount)
        |> List.foldr (\l r -> l && r) True

research: GameState -> Technology -> GameState
research gs techno =
    if ((EveryDict.get techno gs.technologies == Just Unlocked ) && (canResearch gs techno)) then {
        gs | technologies = gs.technologies
                                |> EveryDict.update techno (\old -> Just Researched)
                                |> unlockTechnos techno
           , buildings = gs.buildings |> unlockBuildings techno
    } else gs

unlockTechnos: Technology -> (EveryDict Technology TechnologyState) -> (EveryDict Technology TechnologyState)
unlockTechnos techno technoDict =
    let info = technoInfo techno in
    info.unlocksTechnos
        |> List.foldr (\t dict -> EveryDict.update t (\oldval -> Just Unlocked) dict) technoDict

unlockBuildings: Technology -> (EveryDict Building Int) -> (EveryDict Building Int)
unlockBuildings techno buildingDict =
    let info = technoInfo techno in
    info.unlocksBuildings
        |> List.foldr (\t dict -> EveryDict.update t (\oldval -> Just 0) dict) buildingDict


-- Tick update of the game state

tickUpdate: GameState -> Time -> GameState
tickUpdate gs t = 
    let
        delta = t - gs.lastUpdate
    in
        if delta <= 0 then {
            gs | lastUpdate = t
        } else {
            gs | lastUpdate = t
               , storage = tickResources delta gs
        }

tickResources: Time -> GameState -> EveryDict Resource Float
tickResources delta gs =
    let
        ratio = prodMult gs.entropy gs.maxEntropy
    in
    gs.buildings
        |> EveryDict.map (\building count -> computeBuildingProd delta gs building count ratio)
        |> foldl (\_ prod acc -> updateResourcesWithProd acc prod) gs.storage

computeBuildingProd: Time -> GameState -> Building -> Int -> Float -> List (Resource, Float)
computeBuildingProd delta gs building count ratio =
    baseProd gs.buildings gs.technologies building
        |> List.map (\(resource, amount) -> (resource, amount*(toFloat count)*(inSeconds delta)*ratio))

updateResourcesWithProd: EveryDict Resource Float -> List (Resource, Float) -> EveryDict Resource Float
updateResourcesWithProd resources prod =
    prod
        |> List.filter (\(resource, amount) -> amount > 0.0)
        |> List.foldl (\(resource, amount) acc -> EveryDict.update resource (\oldval -> Just (amount + (withDefault 0.0 oldval))) acc) resources
