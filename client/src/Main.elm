module Main exposing (..)

import Config exposing (Config)
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


init : Config -> Result String Route -> ( Model, Cmd Msg )
init config routeResult =
    urlUpdate routeResult
        { route = Routing.routeFromResult routeResult
        , host = config.host
        , serverUrl = config.serverUrl
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
                ! [ fetchRetroItems model.serverUrl retroId
                  , connectWebSocket retroId
                  ]

        CreateRoomRoute ->
            { model
                | route = (Routing.routeFromResult result)
                , formChannel = ""
            }
                ! []

        _ ->
            { model | route = (Routing.routeFromResult result) } ! []


main : Program Config
main =
    Navigation.programWithFlags Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
