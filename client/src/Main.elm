module Main exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Messages exposing (Msg)
import Model exposing (Model)
import Navigation
import RetroApi exposing (fetchRetroItems)
import Routing exposing (Route(CreateRoomRoute, RoomRoute))
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)
import WebSocket exposing (connectWebSocket)


init : Result String Route -> ( Model, Cmd Msg )
init routeResult =
    urlUpdate routeResult
        { route = Routing.routeFromResult routeResult
        , messages = []
        , channel = ""
        , formChannel = ""
        , happyMessage = ""
        , mehMessage = ""
        , sadMessage = ""
        , hideDone = False
        }


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    case Routing.routeFromResult result of
        RoomRoute retroId ->
            { model | route = (Routing.routeFromResult result) }
                ! [ fetchRetroItems retroId
                  , connectWebSocket retroId
                  ]

        _ ->
            { model | route = (Routing.routeFromResult result) } ! []


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
