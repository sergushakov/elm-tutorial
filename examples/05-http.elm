import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task



main : Program Never
main =
  Html.program
    { init = init "boobs"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , errorMessage : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" ""
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error
  | SetTopic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl "", Cmd.none)

    FetchFail x ->
      ({ model | errorMessage = toString x}, Cmd.none)

    SetTopic newTopic ->
      ({model | topic = newTopic}, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , input [ value model.topic, onInput SetTopic ] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , img [src model.gifUrl] []
    , br [] []
    , p [] [ text model.errorMessage ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
