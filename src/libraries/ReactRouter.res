module Router = {
  @module("react-router-dom") @react.component
  external make: (~children: React.element) => React.element = "BrowserRouter"
}
