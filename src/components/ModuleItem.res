type webpackModule = {id: Js.Nullable.t<string>, size: int, identifier: string}

external jsonToModule: Js.Json.t => webpackModule = "%identity"

let appProjectRoot = "/Users/juspay/Code/juspay/rescript-euler-dashboard"
let babelPrefix = "npm@/babel-loader/lib/index.js!"

let moduleItem = (~parentModule as optionalParentModule=None, arg) => {
  let item = arg["item"]
  let webpackModule = item->jsonToModule
  let index = arg["index"]->string_of_int

  let str =
    webpackModule.identifier
    ->Js.String.replaceByRe(
      Js.Re.fromStringWithFlags(`${appProjectRoot}/node_modules`, ~flags="g"),
      "npm@",
      _,
    )
    ->Js.String.replaceByRe(Js.Re.fromStringWithFlags(appProjectRoot, ~flags="g"), "MarketV2@", _)
    ->Js.String.replaceByRe(Js.Re.fromStringWithFlags(babelPrefix, ~flags="g"), "babel << ", _)
    ->Js.String.replaceByRe(%re("/\ [a-z0-9]{32}/"), "", _)
  let optionalParentModuleID =
    optionalParentModule->Belt.Option.flatMap(parentModule => parentModule.id->Js.Nullable.toOption)
  let parentModuleIDStr = optionalParentModuleID->Belt.Option.getWithDefault("--")
  let idVal = switch webpackModule.id->Js.Nullable.toOption {
  | Some(moduleId) => moduleId
  | None => `${parentModuleIDStr}<${index}>`
  }
  let idStr = `M${idVal}`->Utils.padStart(6)
  let sizeStr = webpackModule.size->Belt.Int.toString->Utils.padStart(6)

  let to_ = switch optionalParentModuleID {
  | Some(parentModuleID) => `/modules/${parentModuleID}/${index}`
  | None =>
    switch webpackModule.id->Js.Nullable.toOption {
    | Some(moduleId) => `/modules/${moduleId}`
    | None => "/modules/"
    }
  }

  open ReactRouter
  <Text>
    <Link to={to_}> {React.string(idStr)} </Link> {React.string(`: [size: ${sizeStr}]: ${str}`)}
  </Text>
}
