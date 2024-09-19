// Generated by ReScript, PLEASE EDIT WITH CARE

import * as $$Text from "./Text.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactNativeWeb from "react-native-web";

function ChunkInfo$ChunksList(Props) {
  var title = Props.title;
  var chunkIds = Props.chunkIds;
  var optionalSetTab = Props.setTab;
  if (chunkIds.length !== 0) {
    return React.createElement(ReactNativeWeb.View, {
                children: null
              }, React.createElement($$Text.make, {
                    children: title
                  }), React.createElement(ReactNativeWeb.View, {
                    style: {
                      flexDirection: "row",
                      flexWrap: "wrap"
                    },
                    children: optionalSetTab !== undefined ? chunkIds.map(function (chunkId) {
                            return React.createElement(ReactNativeWeb.Button, {
                                        title: chunkId,
                                        onPress: (function (param) {
                                            return Curry._1(optionalSetTab, "chunks:" + chunkId);
                                          }),
                                        key: chunkId
                                      });
                          }) : null
                  }));
  } else {
    return null;
  }
}

var ChunksList = {
  make: ChunkInfo$ChunksList
};

function ChunkInfo(Props) {
  var activeChunk = Props.activeChunk;
  var setTab = Props.setTab;
  var fileNames = activeChunk.files.join(", ");
  var chunkIdStr = String(activeChunk.id);
  var chunkSizeStr = String(activeChunk.size);
  var chunkReason = Belt_Option.getWithDefault(Caml_option.nullable_to_opt(activeChunk.reason), "");
  var modulesLenStr = String(activeChunk.modules.length);
  var tmp = {
    title: "Parent Chunks:",
    chunkIds: activeChunk.parents
  };
  if (setTab !== undefined) {
    tmp.setTab = Caml_option.valFromOption(setTab);
  }
  var tmp$1 = {
    title: "Children Chunks:",
    chunkIds: activeChunk.children
  };
  if (setTab !== undefined) {
    tmp$1.setTab = Caml_option.valFromOption(setTab);
  }
  return React.createElement(ReactNativeWeb.View, {
              children: null
            }, React.createElement($$Text.make, {
                  children: "Chunk #" + chunkIdStr + ": [size " + chunkSizeStr + "] " + chunkReason + " (" + modulesLenStr + " modules) : " + fileNames
                }), React.createElement(ChunkInfo$ChunksList, tmp), React.createElement(ChunkInfo$ChunksList, tmp$1));
}

var make = ChunkInfo;

export {
  ChunksList ,
  make ,
  
}
/* Text Not a pure module */
