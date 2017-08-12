module Game.Buildings exposing (..)

import Game.Resources exposing (..)

type Building
    = SawMill
    | Quarry
    | Mine

-- Provides the base cost of each building
baseCost: Building -> List (Resource, Float)
baseCost b = case b of
    SawMill -> [(Wood, 10), (Iron, 5)]
    Quarry -> [(Wood, 25), (Iron, 10)]
    Mine -> [(Wood, 15), (Minerals, 5)]

-- Provides the tick production of each building
baseProd: Building -> List (Resource, Float)
baseProd b = case b of
    SawMill -> [(Wood, 1)]
    Quarry -> [(Minerals, 1)]
    Mine -> [(Iron, 1)]

-- Provides the entropy increase of building each building
entropyCost: Building -> Float
entropyCost b = case b of
    SawMill -> 1.0
    Quarry -> 1.0
    Mine -> 1.0

description: Building -> String
description b = case b of
    SawMill -> "Produces 1 wood / s"
    Quarry -> "Produces 1 mineral / s"
    Mine -> "Produces 1 iron / s"

initialBuildings: List Building
initialBuildings = [ SawMill, Quarry, Mine ]
