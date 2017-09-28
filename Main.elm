module Main exposing (..)

import Html exposing (Html, div, span, button, text, input, label, fieldset)
import Html.Attributes exposing (type_, style)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { notifications : Bool, autoplay : Bool, location : Bool }


model : Model
model =
    { notifications = False, autoplay = False, location = False }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    fieldset []
        [ label []
            [ input [ type_ "checkbox", onClick ToggleNotifications ] []
            , text "Email Notifications"
            ]
        , label []
            [ input [ type_ "checkbox", onClick ToggleAutoplay ] []
            , text "Video Autoplay"
            ]
        , label []
            [ input [ type_ "checkbox", onClick ToggleLocation ] []
            , text "Use Location"
            ]
        ]



-- UPDATE


type Msg
    = ToggleNotifications
    | ToggleAutoplay
    | ToggleLocation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )



-- SUBS


main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
