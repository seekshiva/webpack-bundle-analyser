import React, { useState } from "react";

const JsonFileReader = ({ nullableJson, setNullableJson }) => {
  const [jsonData, setJsonData] = useState(null); // State to hold parsed JSON
  const [error, setError] = useState(null); // State to hold error messages

  // Handler for file input change event
  const handleFileChange = (event) => {
    const file = event.target.files[0]; // Get the first selected file

    // Reset previous state
    setJsonData(null);
    setError(null);

    if (!file) {
      setError("No file selected.");
      return;
    }

    // Optional: Validate file type based on MIME type or file extension
    const validMimeTypes = ["application/json"];
    const validExtensions = [".json"];

    const fileName = file.name;
    const fileExtension = fileName
      .substring(fileName.lastIndexOf("."))
      .toLowerCase();

    if (
      !validMimeTypes.includes(file.type) &&
      !validExtensions.includes(fileExtension)
    ) {
      setError("Please select a valid JSON file.");
      return;
    }

    const reader = new FileReader();

    // Define the onload callback
    reader.onload = (e) => {
      try {
        const text = e.target.result;
        const parsedData = JSON.parse(text);

        console.log({ parsedData });
        const parsedData2 = {}; // JSON.parse(text);
        setJsonData(parsedData);
        setNullableJson(parsedData);
      } catch (parseError) {
        setError(`Error parsing JSON: ${parseError.message}`);
      }
    };

    // Define the onerror callback
    reader.onerror = () => {
      setError("Error reading file.");
    };

    // Read the file as text
    reader.readAsText(file);
  };

  return (
    <div style={styles.container}>
      <h2>webpack-bundle-analyzer</h2>
      <p>This app allows for analyzing webpack bundles for performance.</p>
      <p>
        To run webpack in JSON output mode, use the command:{" "}
        <code>webpack --json {">"} stats.json</code>. Once the JSON file is
        created, please select it here using the file picker.
      </p>
      <input
        type="file"
        accept=".json,application/json"
        onChange={handleFileChange}
        style={styles.input}
      />
      {error && <div style={styles.error}>{error}</div>}
      {jsonData && (
        <pre style={styles.pre}>
          {JSON.stringify(Object.keys(jsonData), null, 2)}
        </pre>
      )}
    </div>
  );
};

// Inline styles for basic styling
const styles = {
  container: {
    fontFamily: "Arial, sans-serif",
    maxWidth: "600px",
    margin: "50px auto",
    padding: "20px",
    border: "2px solid #f0f0f0",
    borderRadius: "8px",
    boxShadow: "0 4px 6px rgba(0,0,0,0.1)",
  },
  input: {
    marginTop: "10px",
    marginBottom: "20px",
  },
  error: {
    color: "red",
    marginBottom: "20px",
  },
  pre: {
    backgroundColor: "#f8f8f8",
    padding: "15px",
    borderRadius: "4px",
    overflowX: "auto",
  },
};

export default JsonFileReader;
