module Msg exposing (..)

import Time exposing (Time)
import Game.Objects exposing (..)

type Tab
    = Buildings Level
    | Science
    | Settings

type Msg
    = Tick Time
    | Build Building
    | Research Technology
    | GatherWood | GatherRocks
    | ChangeTab Tab
