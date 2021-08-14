@val external window: {..} = "window"

@module("./AppFiles.js") @val
external useStatJSON: unit => Js.Nullable.t<Js.Json.t> = "useStatJSON"

module ShowChunk = {
  @module("./AppFiles.js") @react.component
  external make: (~match: ReactRouter.matchType, ~json: Js.Json.t) => React.element = "ShowChunk"
}
module ModuleList = {
  @module("./AppFiles.js") @react.component
  external make: (~match: ReactRouter.matchType, ~json: Js.Json.t) => React.element = "ModuleList"
}
module ShowModule = {
  @module("./AppFiles.js") @react.component
  external make: (~match: ReactRouter.matchType, ~json: Js.Json.t) => React.element = "ShowModule"
}

module Tabs = {
  @module("./AppFiles.js") @react.component
  external make: (
    ~match: ReactRouter.matchType,
    ~currentTab: string,
    ~setTab: (string => string) => unit,
  ) => React.element = "Tabs"
}

let styles = ReactNative.createStyleSheet({
  "container": {
    "flex": 1,
    "backgroundColor": "#fff",
    "height": window["innerHeight"],
  },
  "centeredContent": {
    "alignItems": "center",
  },
  "monospaceText": {"fontFamily": "monospace"},
})

module Text = {
  @react.component
  let make = (~children, ~style=Js.Nullable.null) => {
    open ReactNative

    <ReactNativeText style={ReactNative.flattenStyles([styles["monospaceText"], style])}>
      children
    </ReactNativeText>
  }
}

module ChunkList = {
  type chunk = {id: string, size: int, reason: Js.Nullable.t<string>, modules: array<int>}
  external jsonToChunk: Js.Json.t => chunk = "%identity"

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
}

module LoadedApp = {
  @react.component
  let make = (~json: Js.Json.t) => {
    let (currentTab, setTab) = React.useState(() => "chunks")

    open ReactNative
    open ReactRouter

    <View style={styles["container"]}>
      <View style={styles["centeredContent"]}>
        <Text> {React.string("Open up App.js to start working on your app!")} </Text>
        <Route render={({match}) => <Tabs match currentTab={currentTab} setTab={setTab} />} />
      </View>
      <Switch>
        <Route path="/" exact=true render={({match}) => <ChunkList match json />} />
        <Route path="/chunks" exact=true render={({match}) => <ChunkList match json />} />
        <Route path="/chunks/:chunkID" exact=true render={({match}) => <ShowChunk match json />} />
        <Route path="/modules" exact=true render={({match}) => <ModuleList match json />} />
        <Route
          path="/modules/:moduleID" exact=true render={({match}) => <ShowModule match json />}
        />
        <Route
          path="/modules/:moduleID/:subModuleIndex"
          exact=true
          render={({match}) => <ShowModule match json />}
        />
      </Switch>
    </View>
  }
}

@react.component
let make = () => {
  let nullableJson = useStatJSON()
  window["json"] = nullableJson
  Js.log2("json", nullableJson)
  switch nullableJson->Js.Nullable.toOption {
  | Some(json) => {
      open ReactRouter
      <Router> <LoadedApp json={json} /> </Router>
    }
  | None => {
      open ReactNative
      <ActivityIndicator />
    }
  }
}

let default = make
