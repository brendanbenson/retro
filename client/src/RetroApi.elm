module RetroApi exposing (..)

import Http
import Messages exposing (Msg(FetchRetroDone, FetchRetroFail))
import Task
import Json.Decode as Decode exposing ((:=))
import Model exposing (AddRetroResponse, RetroId)


fetchRetroItems : String -> RetroId -> Cmd Msg
fetchRetroItems serverUrl retroId =
    Http.get collectionDecoder (fetchAllUrl serverUrl retroId)
        |> Task.perform FetchRetroFail FetchRetroDone


fetchAllUrl : String -> RetroId -> String
fetchAllUrl serverUrl retroId =
    serverUrl ++ "/api/retros/" ++ retroId


collectionDecoder : Decode.Decoder (List AddRetroResponse)
collectionDecoder =
    Decode.list retroResponseDecoder


retroResponseDecoder : Decode.Decoder AddRetroResponse
retroResponseDecoder =
    Decode.object5 AddRetroResponse
        ("id" := Decode.int)
        ("message" := Decode.string)
        ("itemType" := Decode.string)
        (Decode.maybe ("archivedAt" := Decode.int))
        (Decode.maybe ("finishedAt" := Decode.int))
