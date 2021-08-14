type rnStyle

module ActivityIndicator = {
  @module("react-native") @react.component
  external make: unit => React.element = "ActivityIndicator"
}

module FlatList = {
  @module("react-native") @react.component
  external make: (
    ~data: array<Js.Json.t>,
    ~renderItem: {"item": Js.Json.t} => React.element,
    ~style: rnStyle=?,
  ) => React.element = "FlatList"
}
module ReactNativeText = {
  @module("react-native") @react.component
  external make: (~style: rnStyle=?, ~children: React.element) => React.element = "Text"
}
module View = {
  @module("react-native") @react.component
  external make: (~style: rnStyle=?, ~children: React.element=?) => React.element = "View"
}
module Button = {
  @module("react-native") @react.component
  external make: (~title: string, ~onPress: unit => unit) => React.element = "Button"
}
module ScrollView = {
  @module("react-native") @react.component
  external make: unit => React.element = "ScrollView"
}

@module("react-native") @scope("StyleSheet")
external createStyleSheet: {..} => {..} = "create"

@module("react-native") @scope("StyleSheet")
external flattenStyles: array<Js.Nullable.t<{..}>> => rnStyle = "flatten"

external objToRnStyle: {..} => rnStyle = "%identity"
