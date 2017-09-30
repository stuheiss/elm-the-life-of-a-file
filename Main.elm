module Main exposing (..)

import Html exposing (Html, div, span, button, text, input, label, fieldset, ul, li, p, br)
import Html.Attributes exposing (type_, style, checked)
import Html.Events exposing (onClick)
import Set exposing (Set)
import Dict exposing (Dict)


-- MODEL


type alias Model =
    { notifications : Bool
    , autoplay : Autoplay
    , location : Bool
    , animals : List ( String, Bool )
    , fruits : List String
    , selected : Set String
    , languages : Dict String Bool
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


animals =
    [ ( "cat", False )
    , ( "dog", False )
    , ( "horse", False )
    ]


languages =
    Dict.fromList
        [ ( "C", False )
        , ( "perl", False )
        , ( "swift", False )
        , ( "python", False )
        , ( "Elm", False )
        , ( "php", False )
        , ( "haskell", False )
        ]


defaults : Model
defaults =
    Model False (Autoplay False False False) False animals listOfFruits Set.empty languages


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
            [ text "Settings (Record):"
            , fieldset [] settings
            , br [] []
            , text "Fruits (Set):"
            , fieldset [] (List.map (checkboxFruit model.selected) model.fruits)
            , br [] []
            , text "Animals (List):"
            , fieldset [] (List.map (\( name, isChecked ) -> checkboxAnimal ( name, isChecked )) model.animals)
            , br [] []
            , text "Languages (Dict):"
            , fieldset [] (List.map (\( name, isChecked ) -> checkboxLanguage ( name, isChecked )) (Dict.toList model.languages))
            , br [] []
            , text "Model: "
            , text (toString model)
            ]


checkboxLanguage : ( String, Bool ) -> Html Msg
checkboxLanguage ( language, isChecked ) =
    label [ style [ ( "display", "block" ) ] ]
        [ input
            [ type_ "checkbox"
            , checked isChecked
            , onClick (ToggleLanguage language)
            ]
            []
        , text language
        ]


checkboxAnimal : ( String, Bool ) -> Html Msg
checkboxAnimal ( animal, isChecked ) =
    label [ style [ ( "display", "block" ) ] ]
        [ input
            [ type_ "checkbox"
            , checked isChecked
            , onClick (ToggleAnimal animal)
            ]
            []
        , text animal
        ]


checkboxFruit : Set String -> String -> Html Msg
checkboxFruit selectedFruits fruit =
    label [ style [ ( "display", "block" ) ] ]
        [ input
            [ type_ "checkbox"
            , checked (Set.member fruit selectedFruits)
            , onClick (ToggleFruit fruit)
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
    | ToggleFruit String
    | ToggleAnimal String
    | ToggleLanguage String


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

        ToggleFruit fruit ->
            let
                newselected =
                    if Set.member fruit model.selected then
                        Set.remove fruit model.selected
                    else
                        Set.insert fruit model.selected
            in
                ( { model | selected = newselected }, Cmd.none )

        ToggleAnimal animal ->
            ( { model
                | animals =
                    List.map
                        (\( name, checked ) ->
                            if name == animal then
                                ( name, not checked )
                            else
                                ( name, checked )
                        )
                        model.animals
              }
            , Cmd.none
            )

        ToggleLanguage language ->
            ( { model
                | languages =
                    Dict.update language
                        (\v ->
                            case v of
                                Nothing ->
                                    Nothing

                                Just b ->
                                    Just (not b)
                        )
                        model.languages
              }
            , Cmd.none
            )

        Noop ->
            ( model, Cmd.none )



-- SUBS


main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
