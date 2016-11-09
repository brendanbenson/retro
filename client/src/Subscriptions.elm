module Subscriptions exposing (subscriptions)

import Messages exposing (Msg(ReceiveMessage))
import Model exposing (Model)
import WebSocket exposing (receiveMessage)


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveMessage ReceiveMessage
