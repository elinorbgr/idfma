module Game.Buildings exposing (..)

import EveryDict exposing (..)

import Game.Objects exposing (..)
import Game.Resources exposing (..)

-- Provides the base cost of each building
baseCost: Building -> List (Resource, Float)
baseCost b = let info = buildingInfo b in info.cost

-- Provides the tick production of each building
baseProd: (EveryDict Building Int) -> (EveryDict Technology TechnologyState) -> Building -> List (Resource, Float)
baseProd blist tlist b = let info = buildingInfo b in info.prod blist tlist

-- Provides the entropy increase of building each building
entropyCost: Building -> Float
entropyCost b = let info = buildingInfo b in info.entropyCost

levelOf: Building -> Level
levelOf b = let info = buildingInfo b in info.level

initialBuildings: List Building
initialBuildings = [ SawMill, Quarry, Mine, Laboratory ]

type alias BuildingInfo =
    { cost: List (Resource, Float)
    , prod: (EveryDict Building Int) -> (EveryDict Technology TechnologyState) -> List (Resource, Float)
    , entropyCost: Float
    , description: String
    , flavor: String
    , level: Level
    }

buildingInfo: Building -> BuildingInfo
buildingInfo b = case b of
    SawMill ->
        { cost = [(Wood, 10), (Iron, 5)]
        , prod = \b t -> [(Wood, 1)]
        , entropyCost = 1.0
        , description = "Produces 1 wood / s"
        , flavor = ""
        , level = Planetary
        }
    Quarry ->
        { cost = [(Wood, 25), (Iron, 10)]
        , prod = \b t -> [(Minerals, 1)]
        , entropyCost = 1.0
        , description = "Produces 1 mineral / s"
        , flavor = ""
        , level = Planetary
        }
    Mine ->
        { cost = [(Wood, 15), (Minerals, 5)]
        , prod = \b t -> [(Iron, 1)]
        , entropyCost = 1.0
        , description = "Produces 1 iron / s"
        , flavor = ""
        , level = Planetary
        }
    Laboratory ->
        { cost = [(Wood, 100), (Minerals, 150), (Iron, 75)]
        , prod = \b t -> [(Science, 1)]
        , entropyCost = 5.0
        , description = "Produces 1 science / s"
        , flavor = ""
        , level = Planetary
        }

