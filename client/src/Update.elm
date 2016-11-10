module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model)
import Navigation
import RetroApi exposing (fetchRetroItems)
import WebSocket exposing (addRetroItem, connectWebSocket, markRetroItemDone, markRetroItemUndone)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateChannel newChannel ->
            { model | formChannel = newChannel } ! []

        SetChannel newChannel ->
            { model
                | channel = newChannel
                , messages = []
            }
                ! [ Navigation.newUrl ("#" ++ newChannel)
                  ]

        UpdateHappyMessage newMessage ->
            ( { model | happyMessage = newMessage }, Cmd.none )

        SendHappyMessage ->
            case model.happyMessage of
                "" ->
                    model ! []

                _ ->
                    { model | happyMessage = "" }
                        ! [ addRetroItem { from = "Bob", text = model.happyMessage, sentiment = "Happy" }
                          ]

        UpdateMehMessage newMessage ->
            ( { model | mehMessage = newMessage }, Cmd.none )

        SendMehMessage ->
            case model.happyMessage of
                "" ->
                    model ! []

                _ ->
                    { model | mehMessage = "" }
                        ! [ addRetroItem { from = "Bob", text = model.mehMessage, sentiment = "Meh" }
                          ]

        UpdateSadMessage newMessage ->
            ( { model | sadMessage = newMessage }, Cmd.none )

        SendSadMessage ->
            case model.happyMessage of
                "" ->
                    model ! []

                _ ->
                    { model | sadMessage = "" }
                        ! [ addRetroItem { from = "Bob", text = model.sadMessage, sentiment = "Sad" }
                          ]

        ReceiveMessage messagesList ->
            { model | messages = messagesList } ! []

        FetchRetroDone messagesList ->
            { model | messages = messagesList } ! []

        FetchRetroFail _ ->
            model ! []

        FinishRetroItem retroItemId ->
            model ! [ markRetroItemDone retroItemId ]

        UnfinishRetroItem retroItemId ->
            model ! [ markRetroItemUndone retroItemId ]

        SetHideDone val ->
            { model | hideDone = val } ! []
