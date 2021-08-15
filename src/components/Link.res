@react.component
let make = (~to: string, ~children) => {
  let handleClick = React.useCallback1(ev => {
    ReactEvent.Mouse.stopPropagation(ev)
    ReactEvent.Mouse.preventDefault(ev)
    RescriptReactRouter.push(to)
  }, [to])
  <a href=to onClick=handleClick> children </a>
}
