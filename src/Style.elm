module Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)

type CssClasses
    = Active
    | Inactive
    | Name

type CssIds
    = BuildingList
    | ResourceList
    | TabList
    | Tab

css =
    (stylesheet << namespace "idfma")
    [ body
        [ backgroundColor (hex "FFFFFF")
        ]
    , id ResourceList
        [ listStyle none
        , border3 (px 1) solid (hex "000000")
        , borderRadius (px 4)
        , children
            [ li
                [ (display inlineBlock) |> important
                , border3 (px 1) solid (hex "000000")
                , borderRadius (px 4)
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
    , id TabList
        [ listStyle none
        , border3 (px 1) solid (hex "000000")
        , borderRadius (px 4)
        , float left
        , children
            [ li
                [ border3 (px 1) solid (hex "000000")
                , borderRadius (px 4)
                , padding (px 8)
                , margin (px 8)
                , cursor pointer
                , hover
                    [ boxShadow6 inset (px 0) (px 0) (px 0) (px 1) (hex "000000")
                    ]
                ]
            , class Active
                [ fontWeight bold
                ]
            ]
        ]
    , id BuildingList
        [ listStyle none
        , border3 (px 1) solid (hex "000000")
        , borderRadius (px 4)
        , marginLeft (px 350)
        , maxWidth (px 620)
        , minHeight (px 30)
        , children
            [ li
                [ (display inlineBlock) |> important
                , border3 (px 1) solid (hex "000000")
                , borderRadius (px 4)
                , width (px 250)
                , padding (px 8)
                , margin (px 8)
                , withClass Active
                    [ hover
                        [ boxShadow6 inset (px 0) (px 0) (px 0) (px 1) (hex "000000")
                        ]
                    ]
                ]
            ]
        ]
    , class Name
        [ fontWeight bold
        ]
    , class Active
        [ cursor pointer
        ]
    , class Inactive
        [ backgroundColor (hex "B0B0B0")
        ]
    ]

