module Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)

type CssClasses
    = BuildingActive
    | BuildingInactive
    | BuildingName

type CssIds
    = BuildingList
    | ResourceList
    | GatherList

css =
    (stylesheet << namespace "idfma")
    [ body
        [ backgroundColor (hex "FFFFFF")
        ]
    , id ResourceList
        [ listStyle none
        , children
            [ li
                [ (display inlineBlock) |> important
                , border3 (px 1) solid (hex "000000")
                , padding (px 2)
                , margin (px 2)
                , children
                    [ span
                        [ margin (px 2)
                        ]
                    ]
                ]
            ]
        ]
    , id GatherList
        [ listStyle none
        , children
            [ li
                [ (display inlineBlock) |> important
                , border3 (px 1) solid (hex "000000")
                , padding (px 8)
                , margin (px 8)
                , cursor pointer
                ]
            ]
        ]
    , id BuildingList
        [ listStyle none
        , children
            [ li
                [ (display inlineBlock) |> important
                , border3 (px 1) solid (hex "000000")
                , padding (px 8)
                , margin (px 8)
                , cursor pointer
                ]
            ]
        ]
    , class BuildingName
        [ fontWeight bold
        ]
    ]


