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

initializeBodyStyle()

let default = make
