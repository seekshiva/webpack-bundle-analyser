@val external window: {..} = "window"

open ReactRouter

module ActivityIndicator = {
  @module("react-native") @react.component
  external make: unit => React.element = "ActivityIndicator"
}
module LoadedApp = {
  @module("./AppFiles.js") @react.component
  external make: (~json: Js.Json.t) => React.element = "LoadedApp"
}

@module("./AppFiles.js") @val
external useStatJSON: unit => Js.Nullable.t<Js.Json.t> = "useStatJSON"

@react.component
let make = () => {
  let nullableJson = useStatJSON()
  window["json"] = nullableJson
  Js.log2("json", nullableJson)
  switch nullableJson->Js.Nullable.toOption {
  | Some(json) => <Router> <LoadedApp json={json} /> </Router>
  | None => <ActivityIndicator />
  }
}

let default = make
