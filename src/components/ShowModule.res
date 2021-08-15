external jsonToModule: Js.Json.t => BundledJsonParser.webpackModule = "%identity"
external toJson: 'a => Js.Json.t = "%identity"

module ModuleInfo = {
  @react.component
  let make = (~activeModule: BundledJsonParser.webpackModule) => {
    let modulesCountInfo = switch activeModule.modules->Js.Nullable.toOption {
    | Some(subModules) => {
        let len = subModules->Js.Array.length->Belt.Int.toString
        `(${len} modules)`
      }
    | None => ""
    }
    let moduleId =
      activeModule.id
      ->Js.Nullable.toOption
      ->Belt.Option.map(Belt.Int.toString)
      ->Belt.Option.mapWithDefault("unknownId", x => `#${x}`)

    let moduleSize = activeModule.size->Belt.Int.toString

    let moduleReason = activeModule.reason->Js.Nullable.toOption->Belt.Option.getWithDefault("")

    open ReactNative
    <View>
      <Text>
        {React.string(
          `Module #${moduleId}: [size ${moduleSize}] ${moduleReason} ${modulesCountInfo}`,
        )}
      </Text>
    </View>
  }
}

module ShowModuleInternal = {
  let styles = ReactNative.createStyleSheet({
    "centeredContent": {
      "alignItems": "center",
    },
  })

  @react.component
  let make = (~matchingModule: BundledJsonParser.webpackModule) => {
    let subModules = React.useMemo1(() => {
      let arr = switch matchingModule.modules->Js.Nullable.toOption {
      | Some(arr) => arr
      | None => []
      }
      arr->Js.Array.map(toJson, _)->Js.Array.sortInPlaceWith(Utils.sortBySize, _)
    }, [matchingModule])

    let renderItem = React.useCallback1(arg => {
      ModuleItem.moduleItem(~parentModule=Some(matchingModule), arg)
    }, [matchingModule])

    open ReactNative
    <View style={objToRnStyle({"flex": 1})}>
      <View style={styles["centeredContent"]}> <ModuleInfo activeModule={matchingModule} /> </View>
      {switch matchingModule.source->Js.Nullable.toOption {
      | Some(source) =>
        <ScrollView style={objToRnStyle({"flex": 1})}>
          <Text> {Prettier.format(source, {plugins: []})->React.string} </Text>
        </ScrollView>
      | None => React.null
      }}
      {if subModules->Js.Array.length !== 0 {
        <FlatList data={subModules} renderItem={renderItem} style={objToRnStyle({"flex": 1})} />
      } else {
        React.null
      }}
    </View>
  }
}

@react.component
let make = (~json: Js.Json.t, ~match: ReactRouter.matchType) => {
  let optionalModuleID =
    match.params->Js.Dict.get("moduleID")->Belt.Option.flatMap(Belt.Int.fromString)
  let optionalSubModuleIndex =
    match.params->Js.Dict.get("subModuleIndex")->Belt.Option.flatMap(Belt.Int.fromString)
  // let matchingModuleBase = json.modules.find(c => c.id === moduleID)

  let modules =
    json
    ->Js.Json.decodeObject
    ->Belt.Option.flatMap(Js.Dict.get(_, "modules"))
    ->Belt.Option.flatMap(Js.Json.decodeArray)
    ->Belt.Option.getWithDefault([])
    ->Js.Array.map(jsonToModule, _)

  let optionalMatchingModule = optionalModuleID->Belt.Option.flatMap(moduleID => {
    modules->Js.Array.find((webpackModule: BundledJsonParser.webpackModule) =>
      switch webpackModule.id->Js.Nullable.toOption {
      | Some(id) => id === moduleID
      | None => false
      }
    , _)
  })

  switch optionalMatchingModule {
  | Some(matchingModuleBase) => {
      let matchingModule = switch optionalSubModuleIndex {
      | Some(subModuleIndex) => {
          let subModulesArr =
            matchingModuleBase.modules->Js.Nullable.toOption->Belt.Option.getWithDefault([])
          if subModuleIndex < subModulesArr->Js.Array.length {
            subModulesArr[subModuleIndex]
          } else {
            matchingModuleBase
          }
        }
      | None => matchingModuleBase
      }
      <ShowModuleInternal matchingModule />
    }

  | None =>
    switch optionalModuleID {
    | Some(moduleId) =>
      React.string(`no matching chunk. ${moduleId->Belt.Int.toString} ${Js.typeof(moduleId)}`)
    | None => React.string("moduleID not found in url param")
    }
  }
}
