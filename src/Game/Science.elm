module Game.Science exposing (..)

import Game.Resources exposing(..)
import Game.Objects exposing (..)

type alias TechnologyInfo =
    { description: String
    , cost: List (Resource, Float)
    , unlocksTechnos: List Technology
    , unlocksBuildings: List Building
    }

initialTechnos: List Technology
initialTechnos = [ Thermodynamics ]

technoInfo: Technology -> TechnologyInfo
technoInfo t = case t of
    Thermodynamics ->
        { description = "Understanding of the 2nd principle."
        , cost = [(Science, 1000)]
        , unlocksTechnos = []
        , unlocksBuildings = []
        }
