module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import BackendTask exposing (BackendTask)
import Css
import Css.Global
import Effect exposing (Effect)
import FaIcon
import FatalError exposing (FatalError)
import Html as UnstyledHtml
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Events as Events
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Theme as Theme
import Tailwind.Utilities as Tw
import UrlPath exposing (UrlPath)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Nothing
    }


type Msg
    = SharedMsg SharedMsg
    | ToggleMenu
    | HideMenu


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMenu : Bool
    }


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : UrlPath
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init flags maybePagePath =
    ( { showMenu = False }
    , Effect.none
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SharedMsg globalMsg ->
            ( model, Effect.none )

        ToggleMenu ->
            ( { model | showMenu = not model.showMenu }, Effect.none )

        HideMenu ->
            ( { model | showMenu = False }, Effect.none )


subscriptions : UrlPath -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : BackendTask FatalError Data
data =
    BackendTask.succeed ()


view :
    Data
    ->
        { path : UrlPath
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : List (UnstyledHtml.Html msg), title : String }
view sharedData page model toMsg pageView =
    { body =
        List.map Html.toUnstyled
            [ Css.Global.global Tw.globalStyles
            , Html.header
                [ css
                    [ Tw.shadow_sm
                    , Tw.sticky
                    , Tw.top_0
                    ]
                ]
                [ Html.div
                    [ css
                        [ Tw.flex
                        , Tw.justify_between
                        , Tw.items_center
                        , Tw.w_full
                        , Tw.p_4
                        , Tw.mx_auto
                        , Breakpoints.lg [ Tw.container ]
                        ]
                    ]
                    [ -- Menu Button
                      Html.div
                        [ css
                            [ Tw.text_xs
                            , Tw.flex
                            , Tw.flex_col
                            , Tw.items_center
                            , Tw.justify_center
                            , Tw.h_6
                            , Tw.w_6
                            , Tw.z_40
                            , Tw.text_color Theme.brand_normal
                            , Tw.relative
                            , Tw.text_center
                            , Breakpoints.lg
                                [ Tw.hidden
                                ]
                            , Breakpoints.sm
                                [ Tw.text_base
                                ]
                            ]
                        , Events.onClick ToggleMenu
                        ]
                        [ if model.showMenu then
                            FaIcon.xMark

                          else
                            FaIcon.bars
                        ]

                    -- Logo
                    , Html.a
                        [ Attr.href "/"
                        , css
                            [ Tw.block
                            , Tw.no_underline
                            ]
                        ]
                        [ Html.img
                            [ Attr.src "/Tri-County.png"
                            , css
                                [ Tw.w_24
                                , Breakpoints.sm [ Tw.w_32 ]
                                , Breakpoints.lg [ Tw.w_60 ]
                                ]
                            ]
                            []
                        ]

                    -- Nav
                    , Html.nav
                        [ css
                            [ if model.showMenu then
                                Tw.fixed

                              else
                                Tw.hidden
                            , Tw.top_0
                            , Tw.left_0
                            , Tw.w_11over12
                            , Tw.h_full
                            , Tw.p_4
                            , Tw.pt_20
                            , Tw.bg_color Theme.gray_300
                            , Tw.bg_opacity_95
                            , Breakpoints.sm
                                [ Tw.w_80
                                ]
                            , Breakpoints.lg
                                [ Tw.static
                                , Tw.block
                                , Tw.flex_grow
                                , Tw.max_w_sm
                                , Tw.w_auto
                                , Tw.h_auto
                                , Tw.p_0
                                , Tw.bg_color Theme.transparent
                                ]
                            , Breakpoints.xl
                                [ Tw.max_w_lg
                                ]
                            , Breakpoints.xxl
                                [ Tw.max_w_2xl
                                ]
                            ]
                        ]
                        [ Html.ul
                            [ css
                                [ Tw.text_color Theme.brand_normal
                                , Tw.uppercase
                                , Tw.leading_loose
                                , Tw.text_2xl
                                , Tw.flex
                                , Tw.flex_col
                                , Tw.items_center
                                , Tw.justify_evenly
                                , Breakpoints.lg
                                    [ Tw.flex_row
                                    , Tw.text_xl
                                    ]
                                , Breakpoints.xl
                                    [ Tw.text_2xl
                                    ]
                                ]
                            ]
                          <|
                            List.map
                                (\( href, text ) ->
                                    let
                                        highlightStyle =
                                            [ Tw.text_color Theme.brand_light ]
                                    in
                                    Html.li
                                        [ Events.onClick HideMenu
                                        , css
                                            [ Breakpoints.lg [ Tw.inline ] ]
                                        ]
                                        [ Html.a
                                            [ Attr.href href
                                            , css
                                                [ Css.hover highlightStyle
                                                , Css.focus highlightStyle
                                                ]
                                            ]
                                            [ Html.text text ]
                                        ]
                                )
                                [ ( "/", "Home" )
                                , ( "/showcase", "Showcase" )
                                , ( "/process", "Process" )
                                ]
                        ]

                    -- CTA buttons
                    , Html.div [ css [ Tw.flex, Tw.gap_2 ] ]
                        [ viewCtaLink
                            { icon = FaIcon.phone
                            , text = "Call Now"
                            , href = "tel:+15745967892"
                            , title = "Call Now"
                            }
                        , viewCtaLink
                            { icon = FaIcon.fileInvoice
                            , text = "Get Quote"
                            , href = "/quote"
                            , title = "Get Quote"
                            }
                        ]
                    ]
                ]
                |> Html.map toMsg
            , Html.main_ [ css [ Tw.mx_auto, Tw.container ] ] pageView.body
            , Html.footer [] [] |> Html.map toMsg
            ]
    , title = pageView.title
    }


viewCtaLink :
    { icon : Html Msg
    , text : String
    , href : String
    , title : String
    }
    -> Html Msg
viewCtaLink { icon, text, href, title } =
    let
        highlightStyle =
            [ Tw.bg_color Theme.brand_light ]
    in
    Html.a
        [ Attr.href href
        , Attr.title title
        , css
            [ Tw.text_color Theme.white
            , Tw.bg_color Theme.brand_normal
            , Tw.p_2
            , Tw.rounded_full
            , Tw.no_underline
            , Tw.flex
            , Tw.gap_2
            , Tw.items_center
            , Tw.justify_center
            , Breakpoints.md [ Tw.px_4 ]
            , Css.hover highlightStyle
            , Css.focus highlightStyle
            ]
        ]
        [ Html.div
            [ css
                [ Tw.h_4
                , Tw.w_4
                ]
            ]
            [ icon ]
        , Html.div [ css [ Tw.hidden, Breakpoints.md [ Tw.block ] ] ] [ Html.text text ]
        ]
