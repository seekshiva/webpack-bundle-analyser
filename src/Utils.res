type objWithSize = {size: int}

external jsonToObjWithSize: Js.Json.t => objWithSize = "%identity"

let sortBySize = (modAJson, modBJson) => {
  let modA = modAJson->jsonToObjWithSize
  let modB = modBJson->jsonToObjWithSize
  modA.size < modB.size ? 1 : modA.size > modB.size ? -1 : 0
}

@send
external padStart: (string, int) => string = "padStart"
