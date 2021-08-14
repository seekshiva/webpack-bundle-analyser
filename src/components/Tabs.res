let tabList = ["chunks", "modules"]

@react.component
let make = (
  ~currentTab,
  ~setTab: (string => string) => unit,
  ~match as _: ReactRouter.matchType,
) => {
  // let isModulesListPage = match.path === "/modules"
  // let isChunkListPage = match.path === "/chunks" || match.path === "/"
  // let isChunkShowPage = match.path === "/chunks" || match.path === "/"
  let isCurrentTabInList = Js.Array.includes(currentTab, tabList)

  open ReactNative
  <View style={objToRnStyle({"flexDirection": "row"})}>
    {tabList->Js.Array.mapi((item, index) => {
      let title = if currentTab === item {
        `"${item}"`
      } else {
        item
      }
      <Button key={index->string_of_int} title onPress={() => setTab(_ => item)} />
    }, _)->React.array}
    {if isCurrentTabInList {
      React.null
    } else {
      <Button title={`"${currentTab}"`} onPress={() => setTab(_ => currentTab)} />
    }}
  </View>
}
