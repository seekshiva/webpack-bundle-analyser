@val external window: {..} = "window"

type jsonModule = {default: Js.Json.t}

@val
external webpackDynamicImport: string => Js.Promise.t<jsonModule> = "import"

let useStatJSON = () => {
  let (statJSON, setStatJSON) = React.useState(() => Js.Nullable.null)

  React.useEffect0(() => {
    let _ =
      webpackDynamicImport(
        "/Users/juspay/Code/juspay/rescript-euler-dashboard/stat.json",
      )->Js.Promise.then_(json => {
        setStatJSON(_ => json.default->Js.Nullable.return)
        Js.Promise.resolve(Js.Nullable.null)
      }, _)
    None
  })

  statJSON
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
})

module LoadedApp = {
  @react.component
  let make = (~json: Js.Json.t) => {
    let (currentTab, setTab) = React.useState(() => "chunks")
    let url = RescriptReactRouter.useUrl()

    open ReactNative

    <View style={styles["container"]}>
      <View style={styles["centeredContent"]}>
        <Text> {React.string("Open up App.js to start working on your app!")} </Text>
        <Tabs currentTab={currentTab} setTab={setTab} />
      </View>
      {switch url.path {
      | list{"modules", moduleID, subModuleIndex} => {
          let optionalModuleID = moduleID->Belt.Int.fromString
          let optionalSubModuleIndex = subModuleIndex->Belt.Int.fromString

          switch optionalModuleID {
          | Some(moduleID) => <ShowModule moduleID subModuleIndex=?optionalSubModuleIndex json />
          | None => React.string("moduleID needs to be of int type")
          }
        }
      | list{"modules", moduleId} => {
          let optionalModuleID = moduleId->Belt.Int.fromString

          switch optionalModuleID {
          | Some(moduleID) => <ShowModule moduleID json />
          | None => React.string("no module id found in url")
          }
        }
      | list{"modules"} => <ModuleList json />
      | list{"chunks", chunkId} => {
          let optionalChunkID = chunkId->Belt.Int.fromString
          switch optionalChunkID {
          | Some(chunkID) => <ShowChunk chunkID json />
          | None => React.string("chunkId is expected to be int type")
          }
        }
      | list{"chunks"} => <ChunkList json />
      | list{} => <ChunkList json />
      | _ => React.string("unknown page")
      }}
    </View>
  }
}

@val @scope(("document", "body"))
external bodyStyle: {..} = "style"

let initializeBodyStyle = () => {
  bodyStyle["margin"] = 0
  bodyStyle["overflow-y"] = "hidden"
  bodyStyle["position"] = "fixed"
  bodyStyle["display"] = "flex"
  bodyStyle["flexDirection"] = "column"
  bodyStyle["width"] = "100%"
  bodyStyle["height"] = "100%"
}

@react.component
let make = () => {
  let nullableJson = useStatJSON()
  window["json"] = nullableJson
  Js.log2("json", nullableJson)
  switch nullableJson->Js.Nullable.toOption {
  | Some(json) => <LoadedApp json={json} />
  | None => {
      open ReactNative
      <ActivityIndicator />
    }
  }
}

initializeBodyStyle()

let default = make
