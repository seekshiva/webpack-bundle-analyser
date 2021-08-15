import { useState, useEffect } from 'react';

document.body.style.margin = 0;
document.body.style['overflow-y'] = 'hidden';
document.body.style.position = 'fixed';
document.body.style.display = 'flex';
document.body.style.flexDirection = 'column';
document.body.style.width = '100%';
document.body.style.height = '100%';


export function useStatJSON() {
  const [statJSON, setStatJSON] = useState(null);

  useEffect(() => {
    import(
      '/Users/juspay/Code/juspay/rescript-euler-dashboard/stat.json'
    ).then(json => setStatJSON(json.default));
  }, []);

  return statJSON;
}

