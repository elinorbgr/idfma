module Game.GameState exposing (GameState, newGame, tickUpdate, build, gather, canBuild)

import Time exposing (Time, inSeconds)
import EveryDict exposing (..)
import Maybe exposing (..)

import Game.Resources exposing (Resource)
import Game.Buildings exposing (Building, Level, initialLevel, baseProd, baseCost, entropyCost, initialBuildings)
import Game.Entropy exposing (prodMult)

type alias GameState =
    { lastUpdate: Time
    , storage: EveryDict Resource Float
    , buildings: EveryDict Building Int
    , level: Level
    , entropy: Float
    , maxEntropy: Float
    }

newGame: GameState
newGame =
    { lastUpdate = 0.0
    , storage = empty
    , buildings = EveryDict.fromList (initialBuildings |> List.map (\b -> (b, 0)))
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

-- Tick update of the game state

tickUpdate: GameState -> Time -> GameState
tickUpdate gs t = 
    let
        delta = t - gs.lastUpdate
        entropyRatio = prodMult gs.entropy gs.maxEntropy
    in
        if delta <= 0 then {
            gs | lastUpdate = t
        } else {
            gs | lastUpdate = t
               , storage = tickResources delta gs.storage gs.buildings entropyRatio
        }

tickResources: Time -> EveryDict Resource Float -> EveryDict Building Int -> Float -> EveryDict Resource Float
tickResources delta resources buildings ratio =
    buildings
        |> EveryDict.map (\building count -> computeBuildingProd delta building count ratio)
        |> foldl (\_ prod acc -> updateResourcesWithProd acc prod) resources

computeBuildingProd: Time -> Building -> Int -> Float -> List (Resource, Float)
computeBuildingProd delta building count ratio =
    baseProd building
        |> List.map (\(resource, amount) -> (resource, amount*(toFloat count)*(inSeconds delta)*ratio))

updateResourcesWithProd: EveryDict Resource Float -> List (Resource, Float) -> EveryDict Resource Float
updateResourcesWithProd resources prod =
    prod
        |> List.filter (\(resource, amount) -> amount > 0.0)
        |> List.foldl (\(resource, amount) acc -> EveryDict.update resource (\oldval -> Just (amount + (withDefault 0.0 oldval))) acc) resources
