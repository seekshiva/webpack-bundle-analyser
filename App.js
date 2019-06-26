import React, { useState, useEffect } from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';

const appProjectRoot =
  '/Users/shiva/Code/inkmonk/webapp/inkmonkweb/static/clients/MarketV2';
const babelPrefix = 'npm@/babel-loader/lib/index.js!';

function useStatJSON() {
  const [statJSON, useStatJSON] = useState(null);

  useEffect(() => {
    import(
      '/Users/shiva/Code/inkmonk/webapp/inkmonkweb/static/clients/MarketV2/stats.json'
    ).then(json => useStatJSON(json));
  }, []);

  return statJSON;
}

export default function App() {
  const json = useStatJSON();
  if (!json) {
    return <ActivityIndicator />;
  } else {
    const modules = json.modules
      .map(m => m.identifier)
      .map(identifier => {
        return identifier
          .replace(new RegExp(`${appProjectRoot}/node_modules`, 'g'), 'npm@')
          .replace(new RegExp(appProjectRoot, 'g'), 'MarketV2@')
          .replace(new RegExp(babelPrefix, 'g'), 'babel << ')
          .replace(/\ [a-z0-9]{32}/, '');
      });
    const str = modules.map((str, index) => `${index}. ${str}`).join('\n');

    return (
      <View style={styles.container}>
        <Text>Open up App.js to start working on your app!</Text>
        <pre>{str}</pre>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
