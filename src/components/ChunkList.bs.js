// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Link from "./Link.bs.js";
import * as $$Text from "./Text.bs.js";
import * as Utils from "../Utils.bs.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactNativeWeb from "react-native-web";

function chunkItem(arg) {
  var itemJson = arg.item;
  var chunkId = String(itemJson.id);
  var chunkIDStr = ("#" + chunkId).padStart(4);
  var sizeStr = String(itemJson.size).padStart(6);
  var modulesLenStr = String(itemJson.modules.length);
  var chunkReason = Belt_Option.getWithDefault(Caml_option.nullable_to_opt(itemJson.reason), "");
  return React.createElement(ReactNativeWeb.View, {
              style: {
                flexDirection: "row",
                alignItems: "center",
                padding: 5
              },
              children: null
            }, React.createElement(Link.make, {
                  to: "/chunks/" + chunkId,
                  children: "Chunk " + chunkIDStr
                }), React.createElement($$Text.make, {
                  children: null
                }, " ", "[size: " + sizeStr + "] " + chunkReason + " (" + modulesLenStr + " modules)"));
}

function ChunkList(Props) {
  var json = Props.json;
  var data = React.useMemo((function () {
          var __x = Belt_Option.getWithDefault(Belt_Option.flatMap(Belt_Option.flatMap(Js_json.decodeObject(json), (function (__x) {
                          return Js_dict.get(__x, "chunks");
                        })), Js_json.decodeArray), []);
          return __x.sort(Utils.sortBySize);
        }), [json]);
  return React.createElement(ReactNativeWeb.View, {
              style: {
                flex: 1,
                overflow: "scroll"
              },
              children: React.createElement(ReactNativeWeb.FlatList, {
                    data: data,
                    renderItem: chunkItem,
                    style: {
                      flex: 1
                    }
                  })
            });
}

var make = ChunkList;

export {
  chunkItem ,
  make ,
  
}
/* Link Not a pure module */
