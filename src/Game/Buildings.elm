module Game.Buildings exposing (..)

import Game.Resources exposing (..)

type Building
    = SawMill
    | Quarry
    | Mine

type Level
    = Planetary
    | Stellar
    | Interstellar
    | Galactic
    | Universal

-- Provides the base cost of each building
baseCost: Building -> List (Resource, Float)
baseCost b = let info = buildingInfo b in info.cost

-- Provides the tick production of each building
baseProd: Building -> List (Resource, Float)
baseProd b = let info = buildingInfo b in info.prod

-- Provides the entropy increase of building each building
entropyCost: Building -> Float
entropyCost b = let info = buildingInfo b in info.entropyCost

levelOf: Building -> Level
levelOf b = let info = buildingInfo b in info.level

initialBuildings: List Building
initialBuildings = [ SawMill, Quarry, Mine ]

initialLevel: Level
initialLevel = Planetary

allLevels: List Level
allLevels = [ Planetary, Stellar, Interstellar, Galactic, Universal ]

levelNumber: Level -> Int
levelNumber l = case l of
    Planetary -> 1
    Stellar -> 2
    Interstellar -> 3
    Galactic -> 4
    Universal -> 5

type alias BuildingInfo =
    { cost: List (Resource, Float)
    , prod: List (Resource, Float)
    , entropyCost: Float
    , description: String
    , flavor: String
    , level: Level
    }

buildingInfo: Building -> BuildingInfo
buildingInfo b = case b of
    SawMill ->
        { cost = [(Wood, 10), (Iron, 5)]
        , prod = [(Wood, 1)]
        , entropyCost = 1.0
        , description = "Produces 1 wood / s"
        , flavor = ""
        , level = Planetary
        }
    Quarry ->
        { cost = [(Wood, 25), (Iron, 10)]
        , prod = [(Minerals, 1)]
        , entropyCost = 1.0
        , description = "Produces 1 mineal / s"
        , flavor = ""
        , level = Planetary
        }
    Mine ->
        { cost = [(Wood, 15), (Minerals, 5)]
        , prod = [(Iron, 1)]
        , entropyCost = 1.0
        , description = "Produces 1 iron / s"
        , flavor = ""
        , level = Planetary
        }

