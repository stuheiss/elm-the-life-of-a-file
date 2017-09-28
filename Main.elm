module Main exposing (..)

import Html exposing (Html, div, span, button, text, input, label, fieldset)
import Html.Attributes exposing (type_, style)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { notifications : Bool, autoplay : Autoplay, location : Bool }


type alias Autoplay =
    { enabled : Bool, audio : Bool, withoutWifi : Bool }


defaults : Model
defaults =
    Model False (Autoplay False False False) False


model : Model
model =
    defaults



-- INIT


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        checkboxes =
            case model.autoplay.enabled of
                True ->
                    [ checkbox ToggleNotifications "Email Notifications"
                    , checkbox ToggleAutoplay "Video Autoplay"
                    , checkbox ToggleAutoplayAudio "Autoplay with audio"
                    , checkbox ToggleAutoplayWithoutWifi "Autoplay without wifi"
                    , checkbox ToggleLocation "Use Location"
                    ]

                False ->
                    [ checkbox ToggleNotifications "Email Notifications"
                    , checkbox ToggleAutoplay "Video Autoplay"
                    , checkbox ToggleLocation "Use Location"
                    ]
    in
        div []
            [ fieldset [] checkboxes
            , text (toString model)
            ]


checkbox : msg -> String -> Html msg
checkbox msg name =
    label [ style [ ( "padding", "20px" ) ] ]
        [ input [ type_ "checkbox", onClick msg ] []
        , text name
        ]



-- UPDATE


type Msg
    = ToggleNotifications
    | ToggleAutoplay
    | ToggleAutoplayAudio
    | ToggleAutoplayWithoutWifi
    | ToggleLocation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleNotifications ->
            ( { model | notifications = not model.notifications }, Cmd.none )

        ToggleAutoplay ->
            let
                autoplay =
                    model.autoplay

                newautoplay =
                    { autoplay | enabled = not model.autoplay.enabled }
            in
                ( { model | autoplay = newautoplay }, Cmd.none )

        ToggleAutoplayAudio ->
            let
                autoplay =
                    model.autoplay

                newautoplay =
                    { autoplay | audio = not model.autoplay.audio }
            in
                ( { model | autoplay = newautoplay }, Cmd.none )

        ToggleAutoplayWithoutWifi ->
            let
                autoplay =
                    model.autoplay

                newautoplay =
                    { autoplay | withoutWifi = not model.autoplay.withoutWifi }
            in
                ( { model | autoplay = newautoplay }, Cmd.none )

        ToggleLocation ->
            ( { model | location = not model.location }, Cmd.none )



-- SUBS


main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
