module View exposing (view)

import Html exposing (..)
import Html.CssHelpers
import Html.Events
import EveryDict exposing (..)
import Round

import Model exposing (Model)
import Style
import Msg exposing (..)
import Settings exposing (..)
import Game.Resources exposing (Resource)
import Game.Buildings exposing (Building, buildingInfo, Level, levelOf, levelNumber, allLevels)
import Game.GameState exposing (GameState, canBuild)

{ id, class, classList } = Html.CssHelpers.withNamespace "idfma"

view : Model -> Html Msg
view model =
    div []
        [ div [] [ resourcesList model.game ]
        , div [] [ renderTabList model ]
        , div [] [ renderTab model ]
        ]

displayAmount: Float -> String
displayAmount val =
    Round.round 2 val

resourcesList: GameState -> Html Msg
resourcesList gs = 
    ul [ id Style.ResourceList ] (List.concat
        [ [ li [] [text "Entropy: ", text (Round.round 2 (gs.entropy / gs.maxEntropy)), text "%" ] ]
        , (EveryDict.toList gs.storage |> List.map (\(resource, amount) -> li [] [
                    span [] [text (toString resource), text ": " ], span [] [text (displayAmount amount) ]
                ])
          )
        ])

renderTabList: Model -> Html Msg
renderTabList model =
    ul [ id Style.TabList ] ( List.concat
        [ (List.take (levelNumber model.game.level) allLevels
            |> List.map (\level -> li
                [ Html.Events.onClick (ChangeTab (Buildings level))
                , class (if model.tab == (Buildings level) then [ Style.Active ] else [])
                ] [ text (toString level), text " buildings" ]
            )
        )
        , [ li
            [ Html.Events.onClick (ChangeTab Settings)
            , class  (if model.tab == Settings then [ Style.Active ] else [])
            ] [ text "Settings" ]
          ]
        ]

    )

renderTab: Model -> Html Msg
renderTab model = case model.tab of
    Buildings level -> buildingsList model.game level
    Settings -> renderSettings model.settings

-- Buildings rendering

buildingsList: GameState -> Level -> Html Msg
buildingsList gs level =
    ul [ id Style.BuildingList ] ( List.concat
        [ (
            if level == Game.Buildings.Planetary then
                [ li [ Html.Events.onClick GatherWood, class [ Style.Active ] ] [ text "Gather wood" ]
                , li [ Html.Events.onClick GatherRocks, class [ Style.Active ] ] [ text "Gather rocks" ]
                ]
            else
                []
        )
        , (
        EveryDict.toList gs.buildings
            |> List.filter (\(building, count) -> levelOf building == level)
            |> List.map (\(building, count) -> renderBuilding gs building count)
        )
        ]
    )

renderBuilding: GameState -> Building -> Int -> Html Msg
renderBuilding gs building count =
    let info = buildingInfo building in
    li [ Html.Events.onClick (Build building), class [ if (canBuild gs building) then Style.Active else Style.Inactive ]]
        [ span [ class [ Style.Name ] ] [ text (toString building), text " (", text (toString count), text ")" ]
        , p [] [ text (info.description) ]
        , p [] [ text "Cost:" ]
        , ul [] (info.cost |> List.map (\(resource, amount) -> li [] [ text (toString resource), text ": ", text (displayAmount amount) ]))
        ]

-- Settings rendering

renderSettings: Settings -> Html Msg
renderSettings settings = p [] []
