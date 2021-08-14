external jsonToChunk: Js.Json.t => BundledJsonParser.chunk = "%identity"

@send
external padStart: (string, int) => string = "padStart"

let chunkItem = arg => {
  let itemJson = arg["item"]
  let webpackChunk = itemJson->jsonToChunk

  let chunkIDStr = `#${webpackChunk.id}`->padStart(4)
  let sizeStr = webpackChunk.size->Belt.Int.toString->padStart(6)

  let modulesLenStr = webpackChunk.modules->Js.Array.length->Belt.Int.toString

  let chunkReason = webpackChunk.reason->Js.Nullable.toOption->Belt.Option.getWithDefault("")

  open ReactNative
  open ReactRouter
  <View style={objToRnStyle({"flexDirection": "row", "alignItems": "center", "padding": 5})}>
    <Link to={`/chunks/${webpackChunk.id}`} style={objToRnStyle({"fontFamily": "monospace"})}>
      {React.string(`Chunk ${chunkIDStr}`)}
    </Link>
    <Text>
      {React.string(" ")}
      {React.string(`[size: ${sizeStr}] ${chunkReason} (${modulesLenStr} modules)`)}
    </Text>
  </View>
}

let sortBySize = (modAJson, modBJson) => {
  let modA = modAJson->jsonToChunk
  let modB = modBJson->jsonToChunk
  modA.size < modB.size ? 1 : modA.size > modB.size ? -1 : 0
}

@react.component
let make = (~json, ~match as _) => {
  let data = React.useMemo1(() => {
    json
    ->Js.Json.decodeObject
    ->Belt.Option.flatMap(Js.Dict.get(_, "chunks"))
    ->Belt.Option.flatMap(Js.Json.decodeArray)
    ->Belt.Option.getWithDefault([])
    ->Js.Array.sortInPlaceWith(sortBySize, _)
  }, [json])

  open ReactNative
  <View style={objToRnStyle({"flex": 1, "overflow": "scroll"})}>
    <FlatList data={data} renderItem={chunkItem} style={objToRnStyle({"flex": 1})} />
  </View>
}
