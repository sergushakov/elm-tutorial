import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing (length)
import Regex

main : Program Never
main =
  App.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age : Int
  , valid : Bool
  , errorMessage : String
  }


model : Model
model =
  Model "" "" "" 0 False ""



-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->
      case String.toInt age of
        Ok newage -> { model | age = newage }
        Err _ -> { model | age = 0, valid = False, errorMessage = "Age must be a number" } -- TODO: side effect, can be refactored

    Validate ->
        let
          (valid, message) = validate model
        in
          { model | valid = valid, errorMessage = message }

      
-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , input [ type' "number", placeholder "Age", onInput Age ] []
    , input [ type' "submit", value "Submit", onClick Validate] []
    , viewValidation model
    ]

validate : Model -> (Bool, String)
validate model =
  if model.password /= model.passwordAgain then
    (False, "Passwords do not match!")
  else if String.length model.password < 8 then
    (False, "Password length must be at least 8 chars")
  else if not (Regex.contains (Regex.regex "[A-Z]") model.password) then
    (False, "Password length must be at least 1 upcase char")
  else if not (Regex.contains (Regex.regex "[0-9]") model.password) then
    (False, "Password length must be at least 1 number")
  else
    (True, "")

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.valid then
        ("green", "OK")
      else
        ("red", model.errorMessage)
  in
    div [ style [("color", color),("display", if String.length model.errorMessage > 0 then "block" else "none")] ] [ text message ]
