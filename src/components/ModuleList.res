@react.component
let make = (~json: Js.Json.t) => {
  let data = React.useMemo1(() => {
    json
    ->Js.Json.decodeObject
    ->Belt.Option.flatMap(Js.Dict.get(_, "modules"))
    ->Belt.Option.flatMap(Js.Json.decodeArray)
    ->Belt.Option.getWithDefault([])
    ->Js.Array.sortInPlaceWith(Utils.sortBySize, _)
  }, [json])

  open ReactNative
  <View style={objToRnStyle({"flex": 1})}>
    <FlatList
      data={data}
      renderItem={ModuleItem.moduleItem(~parentModule=None)}
      style={objToRnStyle({"flex": 1})}
    />
  </View>
}
