module Router = {
  @module("react-router-dom") @react.component
  external make: (~children: React.element) => React.element = "BrowserRouter"
}

type matchType
type renderFnArgs = {match: matchType}

module Route = {
  @module("react-router-dom") @react.component
  external make: (
    ~path: string=?,
    ~exact: bool=?,
    ~render: renderFnArgs => React.element,
  ) => React.element = "Route"
}

module Switch = {
  @module("react-router-dom") @react.component
  external make: (~children: React.element) => React.element = "Switch"
}

module Link = {
  @module("react-router-dom") @react.component
  external make: (
    ~to: string,
    ~style: ReactNative.rnStyle,
    ~children: React.element,
  ) => React.element = "Link"
}
