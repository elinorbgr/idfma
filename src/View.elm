module View exposing (view)

import Html exposing (..)
import Html.CssHelpers
import Html.Events
import EveryDict exposing (..)
import Round

import Model exposing (Model)
import Style
import Msg exposing (..)
import Game.Resources exposing (Resource)
import Game.Buildings exposing (Building)
import Game.GameState exposing (GameState, computeCost)

{ id, class, classList } = Html.CssHelpers.withNamespace "idfma"

view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Entropy: ", text (displayAmount model.game.entropy), text " / ", text (displayAmount model.game.maxEntropy) ]
        , resourcesList model.game
        , gatherList
        , buildingsList model.game
        ]

displayAmount: Float -> String
displayAmount val =
    Round.round 2 val

resourcesList: GameState -> Html Msg
resourcesList gs = 
    ul [ id Style.ResourceList ]
          (EveryDict.toList gs.storage |> List.map (\(resource, amount) -> li [] [
                    span [] [text (toString resource), text ": " ], span [] [text (displayAmount amount) ]
                ])
          )

buildingsList: GameState -> Html Msg
buildingsList gs =
    ul [ id Style.BuildingList ] (EveryDict.toList gs.buildings |> List.map (\(building, count) -> li [] [ renderBuilding gs building count ]))

gatherList: Html Msg
gatherList =
    ul [ id Style.GatherList ]
        [ li [ Html.Events.onClick GatherWood ] [ text "Gather wood" ]
        , li [ Html.Events.onClick GatherRocks ] [ text "Gather rocks" ]
        ]

renderBuilding: GameState -> Building -> Int -> Html Msg
renderBuilding gs building count =
    div [ Html.Events.onClick (Build building) ]
        [ span [ class [ Style.BuildingName ] ] [ text (toString building), text " (", text (toString count), text ")" ]
        , p [] [ text (Game.Buildings.description building) ]
        , p [] [ text "Cost:" ]
        , ul [] (computeCost gs building |> List.map (\(resource, amount) -> li [] [ text (toString resource), text ": ", text (displayAmount amount) ]))
        ]
