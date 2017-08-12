module Model exposing (Model, init, update)

import Html exposing (..)

import Game.GameState exposing (GameState, newGame, tickUpdate, build, gather)
import Game.Resources
import Msg exposing (..)

type alias Model =
    { game: GameState
    }

initialModel : Model
initialModel =
    { game = newGame
    }

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick t ->
            ( { model | game = tickUpdate model.game t }, Cmd.none )
        Build b ->
            ( { model | game = build model.game b }, Cmd.none )
        GatherWood ->
            ( { model | game = gather model.game Game.Resources.Wood }, Cmd.none )
        GatherRocks ->
            ( { model | game = gather model.game Game.Resources.Minerals }, Cmd.none )

