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
import Game.Buildings exposing (Building, baseCost)
import Game.GameState exposing (GameState)

{ id, class, classList } = Html.CssHelpers.withNamespace "idfma"

view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Entropy: ", text (Round.round 2 (model.game.entropy / model.game.maxEntropy)), text "%" ]
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
    ul [ id Style.BuildingList ] (EveryDict.toList gs.buildings |> List.map (\(building, count) -> li [] [ renderBuilding building count ]))

gatherList: Html Msg
gatherList =
    ul [ id Style.GatherList ]
        [ li [ Html.Events.onClick GatherWood ] [ text "Gather wood" ]
        , li [ Html.Events.onClick GatherRocks ] [ text "Gather rocks" ]
        ]

renderBuilding: Building -> Int -> Html Msg
renderBuilding building count =
    div [ Html.Events.onClick (Build building) ]
        [ span [ class [ Style.BuildingName ] ] [ text (toString building), text " (", text (toString count), text ")" ]
        , p [] [ text (Game.Buildings.description building) ]
        , p [] [ text "Cost:" ]
        , ul [] (baseCost building |> List.map (\(resource, amount) -> li [] [ text (toString resource), text ": ", text (displayAmount amount) ]))
        ]
