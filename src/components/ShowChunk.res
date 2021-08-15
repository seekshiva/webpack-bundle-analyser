external jsonToChunk: Js.Json.t => BundledJsonParser.chunk = "%identity"

let styles = ReactNative.createStyleSheet({
  "centeredContent": {
    "alignItems": "center",
  },
})

@react.component
let make = (~json: Js.Json.t, ~chunkID: int) => {
  let chunks =
    json
    ->Js.Json.decodeObject
    ->Belt.Option.flatMap(Js.Dict.get(_, "chunks"))
    ->Belt.Option.flatMap(Js.Json.decodeArray)
    ->Belt.Option.getWithDefault([])
    ->Js.Array.map(jsonToChunk, _)

  let optionalMatchingChunk =
    chunks->Js.Array.find((chunk: BundledJsonParser.chunk) => chunk.id === chunkID, _)

  switch optionalMatchingChunk {
  | Some(matchingChunk) => {
      let data = React.useMemo1(
        () => matchingChunk.modules->Js.Array.sortInPlaceWith(Utils.sortBySize, _),
        [matchingChunk],
      )

      open ReactNative
      <View style={objToRnStyle({"flex": 1})}>
        <View style={styles["centeredContent"]}> <ChunkInfo activeChunk={matchingChunk} /> </View>
        <FlatList
          data={data}
          renderItem={ModuleItem.moduleItem(~parentModule=None)}
          style={objToRnStyle({"flex": 1})}
        />
      </View>
    }
  | None =>
    let chunkIdStr = chunkID->Belt.Int.toString
    let typeofChunkId = Js.typeof(chunkID)
    React.string(`no matching chunk. ${chunkIdStr} ${typeofChunkId}`)
  }
}
