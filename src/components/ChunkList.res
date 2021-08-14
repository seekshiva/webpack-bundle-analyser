external jsonToChunk: Js.Json.t => BundledJsonParser.chunk = "%identity"

let chunkItem = arg => {
  let itemJson = arg["item"]
  let webpackChunk = itemJson->jsonToChunk
  let chunkId = webpackChunk.id->Belt.Int.toString

  let chunkIDStr = `#${chunkId}`->Utils.padStart(4)
  let sizeStr = webpackChunk.size->Belt.Int.toString->Utils.padStart(6)

  let modulesLenStr = webpackChunk.modules->Js.Array.length->Belt.Int.toString

  let chunkReason = webpackChunk.reason->Js.Nullable.toOption->Belt.Option.getWithDefault("")

  open ReactNative
  open ReactRouter
  <View style={objToRnStyle({"flexDirection": "row", "alignItems": "center", "padding": 5})}>
    <Link to={`/chunks/${chunkId}`} style={objToRnStyle({"fontFamily": "monospace"})}>
      {React.string(`Chunk ${chunkIDStr}`)}
    </Link>
    <Text>
      {React.string(" ")}
      {React.string(`[size: ${sizeStr}] ${chunkReason} (${modulesLenStr} modules)`)}
    </Text>
  </View>
}

@react.component
let make = (~json, ~match as _) => {
  let data = React.useMemo1(() => {
    json
    ->Js.Json.decodeObject
    ->Belt.Option.flatMap(Js.Dict.get(_, "chunks"))
    ->Belt.Option.flatMap(Js.Json.decodeArray)
    ->Belt.Option.getWithDefault([])
    ->Js.Array.sortInPlaceWith(Utils.sortBySize, _)
  }, [json])

  open ReactNative
  <View style={objToRnStyle({"flex": 1, "overflow": "scroll"})}>
    <FlatList data={data} renderItem={chunkItem} style={objToRnStyle({"flex": 1})} />
  </View>
}
