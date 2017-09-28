module Main exposing (..)

import Html exposing (Html, div, span, button, text, input, label, fieldset, ul, li, p, br)
import Html.Attributes exposing (type_, style, checked)
import Html.Events exposing (onClick)
import Set exposing (Set)


-- MODEL


type alias Model =
    { notifications : Bool
    , autoplay : Autoplay
    , location : Bool
    , fruits : List String
    , selected : Set String
    }


type alias Autoplay =
    { enabled : Bool, audio : Bool, withoutWifi : Bool }


listOfFruits =
    [ "Apple"
    , "Appricot"
    , "Banana"
    , "Mango"
    , "Orange"
    , "Plum"
    ]


defaults : Model
defaults =
    Model False (Autoplay False False False) False listOfFruits Set.empty


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
        isAutoplay =
            model.autoplay.enabled

        settings =
            [ checkboxSetting True "0" ToggleNotifications "Email Notifications"
            , checkboxSetting True "0" ToggleAutoplay "Video Autoplay"
            , checkboxSetting isAutoplay "20px" ToggleAutoplayAudio "Autoplay with audio"
            , checkboxSetting isAutoplay "20px" ToggleAutoplayWithoutWifi "Autoplay without wifi"
            , checkboxSetting True "0" ToggleLocation "Use Location"
            ]

        fruits =
            List.map (\x -> div [] [ text x ]) model.fruits
    in
        div []
            [ text "Settings:"
            , fieldset [] settings
            , br [] []
            , text "Fruits:"
            , fieldset [] (List.map (checkboxFruits model.selected) model.fruits)
            , br [] []
            , text "Model: "
            , text (toString model)
            ]


checkboxFruits : Set String -> String -> Html Msg
checkboxFruits selectedFruits fruit =
    let
        isChecked =
            Set.member fruit selectedFruits

        message =
            if isChecked then
                Deselect fruit
            else
                Select fruit
    in
        label [ style [ ( "display", "block" ) ] ]
            [ input
                [ type_ "checkbox"
                , checked isChecked
                , onClick message
                ]
                []
            , text fruit
            ]


checkboxSetting : Bool -> String -> msg -> String -> Html msg
checkboxSetting display propPadding msg name =
    let
        propDisplay =
            case display of
                True ->
                    "block"

                False ->
                    "none"
    in
        label [ style [ ( "display", propDisplay ), ( "padding-left", propPadding ) ] ]
            [ input
                [ type_ "checkbox"
                , onClick msg
                ]
                []
            , text name
            ]



-- UPDATE


type Msg
    = ToggleNotifications
    | ToggleAutoplay
    | ToggleAutoplayAudio
    | ToggleAutoplayWithoutWifi
    | ToggleLocation
    | Noop
    | Select String
    | Deselect String


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

        Noop ->
            ( model, Cmd.none )

        Select fruit ->
            ( { model | selected = Set.insert fruit model.selected }, Cmd.none )

        Deselect fruit ->
            ( { model | selected = Set.remove fruit model.selected }, Cmd.none )



-- SUBS


main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
