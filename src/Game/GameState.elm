module Game.GameState exposing (GameState, newGame, tickUpdate, build, computeCost, gather)

import Time exposing (Time, inSeconds)
import EveryDict exposing (..)
import Maybe exposing (..)

import Game.Resources exposing (Resource)
import Game.Buildings exposing (Building, baseProd, baseCost, entropyCost, initialBuildings)
import Game.Entropy exposing (costMult)

type alias GameState =
    { lastUpdate: Time
    , storage: EveryDict Resource Float
    , buildings: EveryDict Building Int
    , entropy: Float
    , maxEntropy: Float
    }

newGame: GameState
newGame =
    { lastUpdate = 0.0
    , storage = empty
    , buildings = EveryDict.fromList (initialBuildings |> List.map (\b -> (b, 0)))
    , entropy = 0.0
    , maxEntropy = 1000.0
    }

-- Gathering
gather: GameState -> Resource -> GameState
gather gs resource =
    { gs | storage = gs.storage |> EveryDict.update resource (\val -> Just (1.0 + (withDefault 0.0 val))) }

-- Building actions

build: GameState -> Building -> GameState
build gs building =
    let
        cost = computeCost gs building
        canBuild = cost |> List.map (\(resource, amount) -> (EveryDict.get resource gs.storage |> withDefault 0.0) >= amount)
                        |> List.foldr (\l r -> l && r) True
    in
        if canBuild then {
            gs | buildings = EveryDict.update building (\count -> Just (1 + (withDefault 0 count))) gs.buildings
               , storage = consume gs.storage cost
               , entropy = gs.entropy + (entropyCost building)
        } else gs

consume: EveryDict Resource Float -> List (Resource, Float) -> EveryDict Resource Float
consume storage cost =
    cost |> List.foldr (\(resource, cost) store ->
                    store |> EveryDict.update resource (\val ->
                        val |> Maybe.map (\v -> v - cost)
                    )
                  ) storage

computeCost: GameState -> Building -> List (Resource, Float)
computeCost gs building =
    let
        -- entropy cost increase is computed from the new entropy that
        -- would e if the building was built
        newEntropy = gs.entropy + (entropyCost building)
        costFactor = costMult newEntropy gs.maxEntropy
    in
        baseCost building
            |> List.map (\(resource, cost) -> (resource, cost*costFactor))

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
               , storage = tickResources delta gs.storage gs.buildings
        }

tickResources: Time -> EveryDict Resource Float -> EveryDict Building Int -> EveryDict Resource Float
tickResources delta resources buildings =
    buildings
        |> EveryDict.map (\building count -> computeBuildingProd delta building count)
        |> foldl (\_ prod acc -> updateResourcesWithProd acc prod) resources

computeBuildingProd: Time -> Building -> Int -> List (Resource, Float)
computeBuildingProd delta building count =
    baseProd building
        |> List.map (\(resource, amount) -> (resource, amount*(toFloat count)*(inSeconds delta)))

updateResourcesWithProd: EveryDict Resource Float -> List (Resource, Float) -> EveryDict Resource Float
updateResourcesWithProd resources prod =
    prod
        |> List.foldl (\(resource, amount) acc -> EveryDict.update resource (\oldval -> Just (amount + (withDefault 0.0 oldval))) acc) resources
