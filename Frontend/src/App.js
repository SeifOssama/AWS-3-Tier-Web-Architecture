import { useState } from "react";

const apiUrl = process.env.REACT_APP_API_URL || "/api";
console.log("Backend API URL is:", apiUrl);

function App() {
  const [message, setMessage] = useState("");

  const fetchMessage = () => {
    fetch(`${apiUrl}/message`)
      .then((res) => res.json())
      .then((data) => setMessage(data.message))
      .catch((err) => {
        console.error("Error fetching message:", err);
        setMessage("Error contacting backend");
      });
  };

  return (
    <div>
      <h1>Frontend</h1>
      <h2>Made by Seif Yakout</h2>
      <button onClick={fetchMessage}>Get Message from Backend</button>
      <p>{message}</p>
    </div>
  );
}

export default App;
