module View exposing (view)

import Html exposing (Html, a, button, div, form, h1, input, label, section, span, text)
import Html.Attributes exposing (autocomplete, autofocus, checked, class, disabled, for, id, placeholder, type', value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)
import Messages exposing (Msg(..))
import Model exposing (Model, AddRetroResponse)
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    let
        content =
            case model.route of
                CreateRoomRoute ->
                    div [ class "frontpage" ]
                        [ div [ class "frontpage-header" ]
                            [ section [ class "url-wrapper" ]
                                [ h1 [ class "inverted" ] [ text "Create a retro and invite anyone" ]
                                , form [ class "url-bar", onSubmit (SetChannel model.formChannel) ]
                                    [ label
                                        [ for "room-name"
                                        , class "inverted"
                                        ]
                                        [ text (model.host ++ "/") ]
                                    , input
                                        [ type' "text"
                                        , value model.formChannel
                                        , onInput UpdateChannel
                                        , id "room-name"
                                        , placeholder "inspirational-panda"
                                        , autocomplete False
                                        , autofocus True
                                        ]
                                        []
                                    , button
                                        [ type' "submit"
                                        , class "ui-button"
                                        ]
                                        [ text "Start" ]
                                    ]
                                ]
                            ]
                        ]

                RoomRoute roomId ->
                    div [ class "retro-page" ]
                        [ div [ class "column-set" ]
                            [ div [ class "column happy" ]
                                (retroPanel
                                    "I'm happy about..."
                                    model.happyMessage
                                    (retroItemsForSentiment "Happy" model)
                                    UpdateHappyMessage
                                    SendHappyMessage
                                )
                            , div [ class "column meh" ]
                                (retroPanel
                                    "I'm confused about..."
                                    model.mehMessage
                                    (retroItemsForSentiment "Meh" model)
                                    UpdateMehMessage
                                    SendMehMessage
                                )
                            , div [ class "column sad" ]
                                (retroPanel
                                    "I'm sad about..."
                                    model.sadMessage
                                    (retroItemsForSentiment "Sad" model)
                                    UpdateSadMessage
                                    SendSadMessage
                                )
                            ]
                        , label [] [ input [ type' "checkbox", checked model.hideDone, onCheck SetHideDone ] [], text "Hide done items" ]
                        ]

                NotFoundRoute ->
                    div [] [ text "Not found" ]
    in
        div [] [ content ]


retroItem : AddRetroResponse -> Html Msg
retroItem item =
    let
        textClass =
            if item.finishedAt == Nothing then
                "retro-item-text"
            else
                "retro-item-text done"

        itemMsg =
            case item.finishedAt of
                Nothing ->
                    FinishRetroItem item.id

                Just timestamp ->
                    UnfinishRetroItem item.id
    in
        div
            [ class "retro-item"
            , onClick itemMsg
            ]
            [ span [ class textClass ] [ text item.message ]
            ]


retroPanel :
    String
    -> String
    -> List AddRetroResponse
    -> (String -> Msg)
    -> Msg
    -> List (Html Msg)
retroPanel placeholderText val retroItems onInputMsg onSubmitMsg =
    (List.concat
        [ [ form [ onSubmit onSubmitMsg ]
                [ input
                    [ type' "text"
                    , value val
                    , onInput onInputMsg
                    , placeholder placeholderText
                    , class "ui-input"
                    ]
                    []
                ]
          ]
        , List.map retroItem retroItems
        ]
    )


retroItemsForSentiment : String -> Model -> List AddRetroResponse
retroItemsForSentiment sentiment model =
    if model.hideDone then
        (List.filter (\a -> a.itemType == sentiment && a.finishedAt == Nothing) model.messages)
    else
        (List.filter (\a -> a.itemType == sentiment) model.messages)
