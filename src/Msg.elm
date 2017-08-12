module Msg exposing (..)

import Time exposing (Time)
import Game.Buildings exposing (Building)

type Msg
    = Tick Time
    | Build Building
    | GatherWood | GatherRocks
