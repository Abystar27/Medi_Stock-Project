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
const { Product } = require("./Models/Product");

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
  sql = "select * from items_inventory";
  db.query(sql).then((results) => {
    //console.log(results);
    res.render("inventory", { items: results });
  });
});

// Create a route for root - /
app.get("/lowstock", (req, res) => {
  // res.render("lowstock");
  sql =
    "SELECT ls.inventory_id,ls.status,inv.name,inv.category,inv.batch_number,inv.expiry_date,ls.quantity,ls.threshold,ls.status \
   FROM low_stock AS ls \
    JOIN items_inventory AS inv \
     ON ls.inventory_id = inv.id;";
  db.query(sql).then((results) => {
    //console.log(results);
    res.render("lowstock", { items: results });
  });
});

// Create a route for root - /
app.get("/expireditems", (req, res) => {
  // res.render("expireditems");
  sql =
    "SELECT exi.inventory_id,inv.id,exi.status,inv.name,inv.category,inv.batch_number,exi.expiry_date,inv.quantity,exi.days_left \
   FROM expired_items AS exi \
    JOIN items_inventory AS inv \
     ON exi.inventory_id = inv.id;";
  db.query(sql).then((results) => {
    //console.log(results);
    res.render("expireditems", { items: results });
  });
});

app.get("/expiringitems", (req, res) => {
  // res.render("expireditems");
  sql =
    "SELECT ex.inventory_id,inv.id,ex.status,inv.name,inv.category,inv.batch_number,ex.expiry_date,inv.quantity,ex.days_left,ex.created_at \
   FROM expiring_soon AS ex \
    JOIN items_inventory AS inv \
     ON ex.inventory_id = inv.id;";
  db.query(sql).then((results) => {
    //console.log(results);
    res.render("expiringitems", { items: results });
  });
});

// Create a route for root - /
app.get("/addstock", (req, res) => {
  res.render("addstock");
});

// app.get("/supplyDetails", (req, res) => {
//   res.render("supplyDetails");
// });

app.get("/productDetails/:id", async (req, res) => {
  var stId = req.params.id;
  // Create a student class with the ID passed
  var product = new Product(stId);
  await product.getProductName();
  await product.getProductCategory();
  await product.getProductQuantity();
  await product.getProductExpiry();
  await product.getProductBatchNo();
  await product.getProductSupplier();
  // await product.getProductPrice();
  await product.getCreatedDate();
  await product.getUpdatedDate();
  console.log(product);
  res.render("productDetails", { product });
});

app.post("/products/delete/:id", async (req, res) => {
  const id = req.params.id;
  var product = new Product(id);
  await product.deleteProduct();
  res.redirect("/inventory");
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
