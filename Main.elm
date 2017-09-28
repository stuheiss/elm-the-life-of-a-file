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
        [ checkbox ToggleNotifications "Email Notifications"
        , checkbox ToggleAutoplay "Video Autoplay"
        , checkbox ToggleLocation "Use Location"
        ]


checkbox : msg -> String -> Html msg
checkbox msg name =
    label []
        [ input [ type_ "checkbox", onClick msg ] []
        , text name
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
