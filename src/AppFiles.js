import React, { useState, useEffect, useMemo, useCallback } from 'react';
import {
  StyleSheet,
  FlatList,
  Text as RNText,
  View,
  Button,
  ScrollView,
} from 'react-native';
import { Link } from 'react-router-dom';
import prettier from 'prettier/standalone';

document.body.style.margin = 0;
document.body.style['overflow-y'] = 'hidden';
document.body.style.position = 'fixed';
document.body.style.display = 'flex';
document.body.style.flexDirection = 'column';
document.body.style.width = '100%';
document.body.style.height = '100%';

function Text(props) {
  return (
    <RNText
      {...props}
      style={StyleSheet.flatten([styles.monospaceText, props.style])}
    />
  );
}

const appProjectRoot =
  '/Users/juspay/Code/juspay/rescript-euler-dashboard';
const babelPrefix = 'npm@/babel-loader/lib/index.js!';

export function useStatJSON() {
  const [statJSON, setStatJSON] = useState(null);

  useEffect(() => {
    import(
      '/Users/juspay/Code/juspay/rescript-euler-dashboard/stat.json'
    ).then(json => setStatJSON(json.default));
  }, []);

  return statJSON;
}

function ModuleItem({ item: webpackModule, parentModule, index }) {
  const str = webpackModule.identifier
    .replace(new RegExp(`${appProjectRoot}/node_modules`, 'g'), 'npm@')
    .replace(new RegExp(appProjectRoot, 'g'), 'MarketV2@')
    .replace(new RegExp(babelPrefix, 'g'), 'babel << ')
    .replace(/\ [a-z0-9]{32}/, '');
  const parentModuleID = parentModule ? parentModule.id : undefined;
  const parentModuleIDStr = parentModuleID || '--';
  const idStr = `M${webpackModule.id ||
    `${parentModuleIDStr}<${index}>`}`.padStart(6);
  const sizeStr = `${webpackModule.size}`.padStart(6);
  const to =
    typeof parentModuleID === 'number'
      ? `/modules/${parentModuleID}/${index}`
      : `/modules/${webpackModule.id}`;
  return (
    <Text>
      <Link to={to}>{idStr}</Link>: [size: {sizeStr}
      ]: {str}
    </Text>
  );
}

function ModuleInfo({ activeModule, setTab }) {
  return (
    <View>
      <Text>
        Module #{activeModule.id}: [size {activeModule.size}]{' '}
        {activeModule.reason}{' '}
        {activeModule.modules
          ? `(${activeModule.modules.length} modules)`
          : null}
      </Text>
    </View>
  );
}

const sortBySize = (modA, modB) =>
  modA.size < modB.size ? 1 : modA.size > modB.size ? -1 : 0;

export function ShowModule({ json, match }) {
  const moduleID = Number(match.params.moduleID);
  const subModuleIndex = Number(match.params.subModuleIndex);
  let matchingModule = json.modules.find(c => c.id === moduleID);
  if (!Number.isNaN(subModuleIndex)) {
    matchingModule = matchingModule.modules[subModuleIndex];
  }
  if (!matchingModule) {
    return `no matching chunk. ${moduleID} ${typeof moduleID}`;
  }
  const subModules = useMemo(
    () => (matchingModule.modules || []).sort(sortBySize),
    [matchingModule.modules]
  );

  const renderItem = useCallback(
    props => <ModuleItem {...props} parentModule={matchingModule} />,
    [matchingModule]
  );

  return (
    <View style={{ flex: 1 }}>
      <View style={styles.centeredContent}>
        <ModuleInfo activeModule={matchingModule} />
      </View>
      {Boolean(matchingModule.source) && (
        <ScrollView style={{ flex: 1 }}>
          <Text>{prettier.format(matchingModule.source, { plugins })}</Text>
        </ScrollView>
      )}
      {subModules.length !== 0 && (
        <FlatList
          data={subModules}
          renderItem={renderItem}
          style={{ flex: 1 }}
        />
      )}
    </View>
  );
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    height: window.innerHeight,
  },
  centeredContent: {
    alignItems: 'center',
  },
  monospaceText: { fontFamily: 'monospace' },
});
