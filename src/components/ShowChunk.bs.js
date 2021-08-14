// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Utils from "../Utils.bs.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as ModuleItem from "./ModuleItem.bs.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactNative from "react-native";
import * as AppFilesJs from "../AppFiles.js";

var make = AppFilesJs.ChunkInfo;

var ChunkInfo = {
  make: make
};

var styles = ReactNative.StyleSheet.create({
      centeredContent: {
        alignItems: "center"
      }
    });

function ShowChunk(Props) {
  var json = Props.json;
  var match = Props.match;
  var optionalChunkID = Belt_Option.flatMap(Js_dict.get(match.params, "chunkID"), Belt_Int.fromString);
  var __x = Belt_Option.getWithDefault(Belt_Option.flatMap(Belt_Option.flatMap(Js_json.decodeObject(json), (function (__x) {
                  return Js_dict.get(__x, "chunks");
                })), Js_json.decodeArray), []);
  var chunks = __x.map(function (prim) {
        return prim;
      });
  var optionalMatchingChunk = Belt_Option.flatMap(optionalChunkID, (function (chunkID) {
          return Caml_option.undefined_to_opt(chunks.find(function (chunk) {
                          return chunk.id === chunkID;
                        }));
        }));
  if (optionalMatchingChunk !== undefined) {
    var data = React.useMemo((function () {
            var __x = optionalMatchingChunk.modules;
            return __x.sort(Utils.sortBySize);
          }), [optionalMatchingChunk]);
    var partial_arg = Caml_option.some(undefined);
    return React.createElement(ReactNative.View, {
                style: {
                  flex: 1
                },
                children: null
              }, React.createElement(ReactNative.View, {
                    style: styles.centeredContent,
                    children: React.createElement(make, {
                          activeChunk: optionalMatchingChunk
                        })
                  }), React.createElement(ReactNative.FlatList, {
                    data: data,
                    renderItem: (function (param) {
                        return ModuleItem.moduleItem(partial_arg, param);
                      }),
                    style: {
                      flex: 1
                    }
                  }));
  }
  if (optionalChunkID === undefined) {
    return "no chunk found. No chunk ID in url";
  }
  var chunkIdStr = String(optionalChunkID);
  var typeofChunkId = typeof optionalChunkID;
  return "no matching chunk. " + chunkIdStr + " " + typeofChunkId;
}

var make$1 = ShowChunk;

export {
  ChunkInfo ,
  styles ,
  make$1 as make,
  
}
/* make Not a pure module */