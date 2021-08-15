type plugin
type formatOptions = {plugins: array<plugin>}

@module("prettier/standalone")
external format: (string, formatOptions) => string = "format"
