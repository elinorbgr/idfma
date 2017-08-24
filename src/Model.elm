module Model exposing (Model, init, update)

import Html exposing (..)

import Game.GameState exposing (GameState, newGame, tickUpdate, build, gather, research)
import Game.Resources
import Game.Objects exposing (Level, initialLevel)
import Msg exposing (..)
import Settings exposing (..)

type alias Model =
    { game: GameState
    , tab: Tab
    , settings: Settings
    }

initialModel : Model
initialModel =
    { game = newGame
    , tab = Buildings initialLevel
    , settings = defaultSettings
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
        Research t ->
            ( { model | game = research model.game t }, Cmd.none )
        GatherWood ->
            ( { model | game = gather model.game Game.Resources.Wood }, Cmd.none )
        GatherRocks ->
            ( { model | game = gather model.game Game.Resources.Minerals }, Cmd.none )
        ChangeTab tab ->
            ( { model | tab = tab }, Cmd.none )
