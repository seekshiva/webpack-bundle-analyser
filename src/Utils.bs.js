// Generated by ReScript, PLEASE EDIT WITH CARE


function sortBySize(modAJson, modBJson) {
  if (modAJson.size < modBJson.size) {
    return 1;
  } else if (modAJson.size > modBJson.size) {
    return -1;
  } else {
    return 0;
  }
}

export {
  sortBySize ,
  
}
/* No side effect */
