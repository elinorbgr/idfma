import Html exposing (..)
--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)

import Time exposing (Time, second)

import Model exposing (Model, init, update)
import Msg exposing (..)
import View exposing (view)

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick
