// Import express.js
const express = require("express");

// Create express app
var app = express();

app.set("view engine", "pug");
app.set("views", "./app/views");

// Add static files location
// app.use(express.static(__dirname + "/public"));
app.use(express.static("public"));

// Get the functions in the db.js file to use
const db = require("./services/db");

// Create a route for root - /
app.get("/", function (req, res) {
  res.render("index");
});

// Create a route for root - /
app.get("/login", function (req, res) {
  res.render("login");
});

// Create a route for root - /
app.get("/dashboard", function (req, res) {
  res.render("dashboard");
});

// Create a route for root - /
app.get("/inventory", (req, res) => {
  // res.render("inventory");
  sql = "select * from inventory";
  db.query(sql).then((results) => {
    console.log(results);
    res.render("inventory", { items: results });
  });
});

// Create a route for root - /
app.get("/lowstock", (req, res) => {
  res.render("lowstock");
});

// Create a route for root - /
app.get("/expireditems", (req, res) => {
  res.render("expireditems");
});

// Create a route for root - /
app.get("/addstock", (req, res) => {
  res.render("addstock");
});

// app.get("/supplyDetails", (req, res) => {
//   res.render("supplyDetails");
// });

app.get("/productDetails/:id", (req, res) => {
  const id = req.params.id;
  db.query("SELECT * FROM inventory WHERE item_id = ?", [id], (err, result) => {
    if (err) throw err;
    res.render("productDetails", { item: result[0] });
  });
});

// Create a route for testing the db
app.get("/db_test", function (req, res) {
  // Assumes a table called test_table exists in your database
  // sql = "select * from inventory";
  // db.query(sql).then((results) => {
  //   console.log(results);
  res.render("index", { items: results });
  //   });
});

// Create a route for /goodbye
// Responds to a 'GET' request
app.get("/goodbye", function (req, res) {
  res.send("Goodbye world!");
});

// Create a dynamic route for /hello/<name>, where name is any value provided by user
// At the end of the URL
// Responds to a 'GET' request
app.get("/hello/:name", function (req, res) {
  // req.params contains any parameters in the request
  // We can examine it in the console for debugging purposes
  console.log(req.params);
  //  Retrieve the 'name' parameter and use it in a dynamically generated page
  res.send("Hello " + req.params.name);
});

// Start server on port 3000
app.listen(3000, function () {
  console.log(`Server running at http://127.0.0.1:3000/`);
});
