const express = require("express");
const app = express();
const port = 5050;

const mysql = require("mysql");
const pool = mysql.createPool({
  host: process.env.RDS_HOSTNAME,
  user: process.env.RDS_USERNAME,
  password: process.env.RDS_PASSWORD,
  port: process.env.RDS_PORT,
  ssl: true,
  connectionLimit: 10, // adjust as needed
});

app.get("/api/message", (req, res) => {
 pool.getConnection(function (err, connection) {
 if (err) {
 console.error("Database connection failed: " + err.stack);
 return res.status(500).json({ message: "db connection failed" }); // ✅ JSON
 }

 console.log("Connected to database.");
 connection.release();
 res.json({ message: "db connection successful finished pipeline" }); // ✅ JSON
 });
});

app.get("/health", (req, res) => {
  res.status(200).send("OK");
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
