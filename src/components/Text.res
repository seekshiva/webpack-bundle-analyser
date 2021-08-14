let styles = ReactNative.createStyleSheet({
  "monospaceText": {"fontFamily": "monospace"},
})

@react.component
let make = (~children, ~style=Js.Nullable.null) => {
  open ReactNative

  <ReactNativeText style={ReactNative.flattenStyles([styles["monospaceText"], style])}>
    children
  </ReactNativeText>
}
