type chunk = {id: string}

type statInfo = {
  hash: string,
  version: string,
  time: int,
  builtAt: int,
  publicPath: string,
  outputPath: string,
  assetsByChunkName: Js.Json.t,
  chunks: array<string>,
}

type parseResult = Parsed(statInfo) | ParseError(string)

let parse = (_json: Js.Json.t) => {
  ParseError("parsing logic not written yet")
}
