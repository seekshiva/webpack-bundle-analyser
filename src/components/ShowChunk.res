external jsonToChunk: Js.Json.t => BundledJsonParser.chunk = "%identity"

module ChunkInfo = {
  @module("../AppFiles.js") @react.component
  external make: (~activeChunk: BundledJsonParser.chunk) => React.element = "ChunkInfo"
}

let styles = ReactNative.createStyleSheet({
  "centeredContent": {
    "alignItems": "center",
  },
})

@react.component
let make = (~json: Js.Json.t, ~match: ReactRouter.matchType) => {
  let optionalChunkID =
    match.params->Js.Dict.get("chunkID")->Belt.Option.flatMap(Belt.Int.fromString)
  let chunks =
    json
    ->Js.Json.decodeObject
    ->Belt.Option.flatMap(Js.Dict.get(_, "chunks"))
    ->Belt.Option.flatMap(Js.Json.decodeArray)
    ->Belt.Option.getWithDefault([])
    ->Js.Array.map(jsonToChunk, _)

  let optionalMatchingChunk = optionalChunkID->Belt.Option.flatMap(chunkID => {
    chunks->Js.Array.find((chunk: BundledJsonParser.chunk) => chunk.id === chunkID, _)
  })

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
    switch optionalChunkID {
    | Some(chunkId) => {
        let chunkIdStr = chunkId->Belt.Int.toString
        let typeofChunkId = Js.typeof(chunkId)
        React.string(`no matching chunk. ${chunkIdStr} ${typeofChunkId}`)
      }
    | None => React.string("no chunk found. No chunk ID in url")
    }
  }
}
