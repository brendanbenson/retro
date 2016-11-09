port module WebSocket exposing (..)

import Dict exposing (Dict)
import Model exposing (AddRetroRequest, AddRetroResponse, RetroItemId)


type alias Channel =
    String


port connectWebSocket : Channel -> Cmd msg


port addRetroItem : AddRetroRequest -> Cmd msg


port markRetroItemDone : RetroItemId -> Cmd msg


port markRetroItemUndone : RetroItemId -> Cmd msg


port receiveMessage : (List AddRetroResponse -> msg) -> Sub msg
