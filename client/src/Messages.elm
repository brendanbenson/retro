module Messages exposing (..)

import Model exposing (AddRetroResponse, RetroId, RetroItemId)
import Http


type Msg
    = UpdateHappyMessage String
    | SendHappyMessage
    | UpdateMehMessage String
    | SendMehMessage
    | UpdateSadMessage String
    | SendSadMessage
    | ReceiveMessage (List AddRetroResponse)
    | UpdateChannel RetroId
    | SetChannel RetroId
    | FetchRetroDone (List AddRetroResponse)
    | FetchRetroFail Http.Error
    | FinishRetroItem RetroItemId
    | SetHideDone Bool
    | UnfinishRetroItem RetroItemId
