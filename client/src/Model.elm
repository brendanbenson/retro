module Model exposing (..)

import Routing exposing (Route)


type alias Model =
    { route : Route
    , messages : List AddRetroResponse
    , happyMessage : String
    , mehMessage : String
    , sadMessage : String
    , channel : RetroId
    , formChannel : RetroId
    , hideDone : Bool
    }


type alias AddRetroRequest =
    { sentiment : String
    , from : String
    , text : String
    }


type alias AddRetroResponse =
    { id : RetroItemId
    , message : String
    , itemType : String
    , archivedAt : Maybe Int
    , finishedAt : Maybe Int
    }


type alias RetroId =
    String


type alias RetroItemId =
    Int
