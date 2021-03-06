import React, { useState, useEffect, useMemo, useCallback } from 'react';
import {
  ActivityIndicator,
  StyleSheet,
  FlatList,
  Text as RNText,
  View,
  Button,
  ScrollView,
} from 'react-native';
import { BrowserRouter as Router, Route, Switch, Link } from 'react-router-dom';
import prettier from 'prettier/standalone';
import babylon from 'prettier/parser-babylon';

const plugins = [babylon];

document.body.style.margin = 0;
document.body.style['overflow-y'] = 'hidden';
document.body.position = 'fixed';
document.body.display = 'flex';
document.body.flexDirection = 'column';
document.body.width = '100%';
document.body.height = '100%';

function Text(props) {
  return (
    <RNText
      {...props}
      style={StyleSheet.flatten([styles.monospaceText, props.style])}
    />
  );
}

const appProjectRoot =
  '/Users/shiva/Code/inkmonk/webapp/inkmonkweb/static/clients/MarketV2';
const babelPrefix = 'npm@/babel-loader/lib/index.js!';

function useStatJSON() {
  const [statJSON, useStatJSON] = useState(null);

  useEffect(() => {
    import(
      '/Users/shiva/Code/inkmonk/webapp/inkmonkweb/static/clients/MarketV2/stats.json'
    ).then(json => useStatJSON(json.default));
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
    <Text style={{ fontFamily: 'monospace' }}>
      <Link to={to}>{idStr}</Link>: [size: {sizeStr}
      ]: {str}
    </Text>
  );
}

function ChunkItem({ item: webpackChunk, setTab }) {
  const chunkIDStr = `#${webpackChunk.id}`.padStart(4);
  const sizeStr = `${webpackChunk.size}`.padStart(6);

  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', padding: 5 }}>
      <Link
        to={`/chunks/${webpackChunk.id}`}
        style={{ fontFamily: 'monospace' }}
      >
        Chunk {chunkIDStr}
      </Link>
      <Text>
        &nbsp;[size: {sizeStr}]&nbsp;{webpackChunk.reason} (
        {webpackChunk.modules.length} modules)
      </Text>
    </View>
  );
}

const tabList = ['chunks', 'modules'];

function Tabs({ currentTab, setTab, match }) {
  const isModulesListPage = match.path === '/modules';
  const isChunkListPage = match.path === '/chunks' || match.path === '/';
  const isChunkShowPage = match.path === '/chunks' || match.path === '/';
  const isCurrentTabInList = tabList.includes(currentTab);
  return (
    <View style={{ flexDirection: 'row' }}>
      {tabList.map((item, index) => (
        <Button
          key={index}
          title={currentTab === item ? `"${item}"` : `${item}`}
          onPress={() => setTab(item)}
        />
      ))}
      {!isCurrentTabInList && (
        <Button title={`"${currentTab}"`} onPress={() => setTab(currentTab)} />
      )}
    </View>
  );
}

function ChunkInfo({ activeChunk, setTab }) {
  return (
    <View>
      <Text>
        Chunk #{activeChunk.id}: [size {activeChunk.size}] {activeChunk.reason}{' '}
        ({activeChunk.modules.length} modules) : {activeChunk.files.join(', ')}
      </Text>
      <View>
        <Text>Parent Chunks:</Text>
        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
          {activeChunk.parents.map(parentID => (
            <Button
              key={parentID}
              title={`${parentID}`}
              onPress={() => setTab(`chunks:${parentID}`)}
            />
          ))}
        </View>
      </View>
      <View>
        <Text>Children Chunks:</Text>
        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
          {activeChunk.children.map(childChunkID => (
            <Button
              title={`${childChunkID}`}
              onPress={() => setTab(`chunks:${childChunkID}`)}
            />
          ))}
        </View>
      </View>
    </View>
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

function ChunkList({ json }) {
  const data = useMemo(() => json.chunks.sort(sortBySize), [json.chunks]);
  return (
    <View style={{ flex: 1 }}>
      <FlatList data={data} renderItem={ChunkItem} style={{ flex: 1 }} />
    </View>
  );
}

function ModuleList({ json }) {
  const data = useMemo(() => json.modules.sort(sortBySize), [json.modules]);
  return (
    <View style={{ flex: 1 }}>
      <FlatList data={data} renderItem={ModuleItem} style={{ flex: 1 }} />
    </View>
  );
}

function ShowChunk({ json, match }) {
  const chunkID = Number(match.params.chunkID);
  const matchingChunk = json.chunks.find(c => c.id === chunkID);
  if (!matchingChunk) {
    return `no matching chunk. ${chunkID} ${typeof chunkID}`;
  }
  const data = useMemo(() => matchingChunk.modules.sort(sortBySize), [
    matchingChunk.modules,
  ]);

  return (
    <View style={{ flex: 1 }}>
      <View style={styles.centeredContent}>
        <ChunkInfo activeChunk={matchingChunk} />
      </View>
      <FlatList data={data} renderItem={ModuleItem} style={{ flex: 1 }} />
    </View>
  );
}

function ShowModule({ json, match }) {
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

function LoadedApp({ json }) {
  const [currentTab, setTab] = useState('chunks');
  return (
    <View style={styles.container}>
      <View style={styles.centeredContent}>
        <Text>Open up App.js to start working on your app!</Text>
        <Route
          render={props => (
            <Tabs {...props} currentTab={currentTab} setTab={setTab} />
          )}
        />
      </View>
      <Switch>
        <Route
          path="/"
          exact
          render={props => <ChunkList {...props} json={json} />}
        />
        <Route
          path="/chunks"
          exact
          render={props => <ChunkList {...props} json={json} />}
        />
        <Route
          path="/chunks/:chunkID"
          exact
          render={props => <ShowChunk {...props} json={json} />}
        />
        <Route
          path="/modules"
          exact
          render={props => <ModuleList {...props} json={json} />}
        />
        <Route
          path="/modules/:moduleID"
          exact
          render={props => <ShowModule {...props} json={json} />}
        />
        <Route
          path="/modules/:moduleID/:subModuleIndex"
          exact
          render={props => <ShowModule {...props} json={json} />}
        />
      </Switch>
    </View>
  );
}

export default function App() {
  const json = useStatJSON();
  window.json = json;
  console.log('json', json);
  if (!json) {
    return <ActivityIndicator />;
  } else {
    return (
      <Router>
        <LoadedApp json={json} />
      </Router>
    );
  }
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
