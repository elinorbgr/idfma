module Msg exposing (..)

import Time exposing (Time)
import Game.Buildings exposing (Building, Level)

type Tab
    = Buildings Level
    | Settings

type Msg
    = Tick Time
    | Build Building
    | GatherWood | GatherRocks
    | ChangeTab Tab
