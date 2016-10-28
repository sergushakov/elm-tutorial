import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Svg
import Svg.Attributes
import Random


main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { dieFace1 : Int
  , dieFace2 : Int
  , isWinner : Bool
  , winsCount : Int
  }

type Msg = Roll
  | NewFace (Int, Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      let
        dieFace1 = Random.generate NewFace (Random.pair (Random.int 1 6) (Random.int 1 6))
      in
        (model, dieFace1)

    NewFace (newFace1, newFace2) ->
      let
        isWin = newFace1 == newFace2
      in
        (Model newFace1 newFace2 isWin (if isWin then model.winsCount + 1 else 0), Cmd.none)

init : (Model, Cmd Msg)
init =

  (Model 1 1 False 0, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Roll ] [ Html.text "Roll" ]
    , diceView model.dieFace1
    , diceView model.dieFace2
    , winnerView model
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

winnerView : Model -> Html.Html Msg
winnerView model =
  div []
    [ h1 [ style [("color", "green"), ("display", if model.isWinner && model.winsCount < 3 then "block" else "none")] ] [ Html.text (if model.winsCount == 2 then "You are lucky again!" else "You are lucky!")]
    , h1 [ style [("color", "red"),("display", if model.winsCount >= 3 then "block" else "none")] ] [ Html.text "You are Loki!"]
    ]


diceView : Int -> Html.Html Msg
diceView dieFace =
  let
    diceFillColor = "#000000"
    dotFillColor = "red"
    dotRadius = "5"
    visibility : List Int -> String
    visibility nums =
      if List.member dieFace nums || dieFace == 6 then
        "visible"
      else
        "hidden"
  in
    Svg.svg
      [ Svg.Attributes.width "120", Svg.Attributes.height "120", Svg.Attributes.viewBox "0 0 120 120" ]
      [ Svg.rect [ Svg.Attributes.x "30"
                 , Svg.Attributes.y "30"
                 , Svg.Attributes.width "60"
                 , Svg.Attributes.height "60"
                 , Svg.Attributes.rx "10"
                 , Svg.Attributes.ry "10"
                 , Svg.Attributes.fill diceFillColor
                 ] []
      , Svg.circle [ Svg.Attributes.cx "40", Svg.Attributes.cy "40", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [5,3,4]) ] []
      , Svg.circle [ Svg.Attributes.cx "60", Svg.Attributes.cy "40", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility []) ] []
      , Svg.circle [ Svg.Attributes.cx "80", Svg.Attributes.cy "40", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [5,4]) ] []
      , Svg.circle [ Svg.Attributes.cx "40", Svg.Attributes.cy "60", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [2]) ] []
      , Svg.circle [ Svg.Attributes.cx "60", Svg.Attributes.cy "60", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [1,3,5]) ] []
      , Svg.circle [ Svg.Attributes.cx "80", Svg.Attributes.cy "60", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [2]) ] []
      , Svg.circle [ Svg.Attributes.cx "40", Svg.Attributes.cy "80", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [4,5]) ] []
      , Svg.circle [ Svg.Attributes.cx "60", Svg.Attributes.cy "80", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility []) ] []
      , Svg.circle [ Svg.Attributes.cx "80", Svg.Attributes.cy "80", Svg.Attributes.r dotRadius, Svg.Attributes.fill dotFillColor, Svg.Attributes.visibility (visibility [5,3,4]) ] []
      ]
