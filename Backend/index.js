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
      res.send("db connection failed");
      console.error("Database connection failed: " + err.stack);
      return;
    }
    res.send("db connection successful finished pipeline");
    console.log("Connected to database.");
    connection.release(); // release back to the pool
  });
});


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
