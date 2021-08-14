module ChunksList = {
  @react.component
  let make = (~title, ~chunkIds, ~setTab as optionalSetTab=?) => {
    open ReactNative
    if chunkIds->Js.Array.length !== 0 {
      <View>
        <Text> {React.string(title)} </Text>
        <View style={objToRnStyle({"flexDirection": "row", "flexWrap": "wrap"})}>
          {switch optionalSetTab {
          | Some(setTab) => chunkIds->Js.Array.map(chunkId => {
              <Button key={chunkId} title={chunkId} onPress={() => setTab(`chunks:${chunkId}`)} />
            }, _)->React.array
          | None => React.null
          }}
        </View>
      </View>
    } else {
      React.null
    }
  }
}

@react.component
let make = (~activeChunk: BundledJsonParser.chunk, ~setTab=?) => {
  let fileNames = activeChunk.files->Js.Array.joinWith(", ", _)
  let chunkIdStr = activeChunk.id->Belt.Int.toString
  let chunkSizeStr = activeChunk.size->Belt.Int.toString
  let chunkReason = activeChunk.reason->Js.Nullable.toOption->Belt.Option.getWithDefault("")
  let modulesLenStr = activeChunk.modules->Js.Array.length->Belt.Int.toString

  open ReactNative
  <View>
    <Text>
      {React.string(
        `Chunk #${chunkIdStr}: [size ${chunkSizeStr}] ${chunkReason} (${modulesLenStr} modules) : ${fileNames}`,
      )}
    </Text>
    <ChunksList title="Parent Chunks:" ?setTab chunkIds=activeChunk.parents />
    <ChunksList title="Children Chunks:" ?setTab chunkIds=activeChunk.children />
  </View>
}
