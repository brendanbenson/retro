module View exposing (view)

import Html exposing (Html, button, div, form, input, label, span, text)
import Html.Attributes exposing (checked, class, disabled, placeholder, type', value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)
import Messages exposing (Msg(..))
import Model exposing (Model, AddRetroResponse)
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    case model.route of
        CreateRoomRoute ->
            div []
                [ input [ type' "text", value model.formChannel, onInput UpdateChannel, placeholder "Channel" ] []
                , button [ type' "button", onClick (SetChannel model.formChannel) ] [ text "Join" ]
                ]

        RoomRoute roomId ->
            div []
                [ div [ class "column-set" ]
                    [ div [ class "column happy" ]
                        (retroPanel
                            "I'm happy that..."
                            model.happyMessage
                            (retroItemsForSentiment "Happy" model)
                            UpdateHappyMessage
                            SendHappyMessage
                        )
                    , div [ class "column meh" ]
                        (retroPanel
                            "I'm confused that..."
                            model.mehMessage
                            (retroItemsForSentiment "Meh" model)
                            UpdateMehMessage
                            SendMehMessage
                        )
                    , div [ class "column sad" ]
                        (retroPanel
                            "I wish that..."
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


retroItem : AddRetroResponse -> Html Msg
retroItem item =
    let
        itemClass =
            if item.finishedAt == Nothing then
                "message"
            else
                "message striked"
    in
        div [ class itemClass ] [ text item.message, retroItemControls item ]


retroItemControls : AddRetroResponse -> Html Msg
retroItemControls item =
    case item.finishedAt of
        Nothing ->
            button [ type' "button", onClick (FinishRetroItem item.id) ] [ text "Done" ]

        Just timestamp ->
            button [ type' "button", onClick (UnfinishRetroItem item.id) ] [ text "Undone" ]


retroPanel :
    String
    -> String
    -> List AddRetroResponse
    -> (String -> Msg)
    -> Msg
    -> List (Html Msg)
retroPanel placeholderText val retroItems onInputMsg onClickMsg =
    (List.concat
        [ [ form [ onSubmit onClickMsg ]
                [ input [ type' "text", value val, onInput onInputMsg, placeholder placeholderText ] []
                , button [ type' "submit", disabled (val == "") ] [ text "Add" ]
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
