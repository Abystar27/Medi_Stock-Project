// Import express.js
const express = require("express");
var app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
// Create express app

app.set("view engine", "pug");
app.set("views", "./app/views");
app.use(express.static("public"));

// Get the functions in the db.js file to use
const db = require("./services/db");
const { Product } = require("./Models/Product");
const { Stock } = require("./Models/Stock");
const { user } = require("./Models/user");

// Create a route for root - /
app.get("/", function (req, res) {
  res.render("index");
});

// Create a route for root - /
app.get("/login", function (req, res) {
  res.render("login");
});

app.post("/authenticate", async function (req, res) {
  params = req.body;
  var User = new user(params.email);
  try {
    uId = await User.getIdFromEmail();
    if (uId) {
      match = await User.authenticate(params.password);
      console.log("checking");
      if (match) {
        res.redirect("/dashboard");
      } else {
        res.render("login", { error: "invalid email or password" });
      }
    } else {
      res.render("login", { error: "invalid email or password" });
    }
  } catch (err) {
    console.error(`Error while comparing `, err.message);
  }
});

app.post("/set-password", async function (req, res) {
  params = req.body;
  var User = new user(params.email);
  User.username = params.username;
  User.role = params.role;
  try {
    uId = await User.getIdFromEmail();
    if (uId) {
      // If a valid, existing user is found, set the password and redirect to the users single-student page
      await User.setUserPassword(params.password);
      console.log(req.session.id);
      res.send("Password set successfully");
    } else {
      // If no existing user is found, add a new one
      newId = await User.addUser(params.password);
      res.status(
        "Perhaps a page where a new user sets a programme would be good here",
      );
      res.redirect("/adminprofile");
    }
  } catch (err) {
    console.error(`Error while adding password `, err.message);
  }
});

// Create a route for root - /
app.get("/dashboard", (req, res) => {
  res.render("dashboard");
});

app.get("/addNewProduct", (req, res) => {
  res.render("addNewProduct");
});

app.get("/adminprofile", (req, res) => {
  sql = "select * from users";
  db.query(sql).then((results) => {
    //console.log(results);
    res.render("adminprofile", { items: results });
  });
});

app.get("/logout", function (req, res) {
  req.session.destroy();
  res.redirect("/login");
});

app.post("/addNewProduct", async (req, res) => {
  // console.log(req.body);
  const {
    name,
    threshold,
    category,
    quantity,
    supplier,
    batch_number,
    expiry_date,
  } = req.body;
  var product = new Stock();
  await product.getNextItemid();
  const item_id = product.item_id;
  console.log(item_id);

  console.log(req.body);

  // res.redirect("/addstock");
  const query = `INSERT INTO items_inventory (item_id, name, category, quantity,batch_number,low_stock_threshold, supplier, expiry_date) VALUES (?, ?, ?, ?, ?, ?,?,?)`;
  db.query(
    query,
    [
      item_id,
      name,
      category,
      quantity,
      batch_number,
      threshold,
      supplier,
      expiry_date,
    ],
    (err, result) => {
      if (err) return res.status(500).send(err);
    },
    console.log("done"),
    // res.redirect("/addstock"),
  );
});

app.get("/inventory", (req, res) => {
  const search = req.query.search;
  const category = req.query.category;

  let sql = "SELECT * FROM items_inventory";
  const values = [];

  if (search && search.trim() !== "") {
    sql += " WHERE name LIKE ?";
    values.push(`%${search}%`);
  } else if (category && category !== "all") {
    sql += " WHERE category = ?";
    values.push(category);
  }

  db.query(sql, values)
    .then((results) => {
      res.render("inventory", { items: results, search, category });
    })
    .catch((err) => res.status(500).send(err));
});

app.get("/activitylog", (req, res) => {
  sql = "select * from activity_logs";
  db.query(sql).then((results) => {
    //console.log(results);
    res.render("activitylog", { items: results });
  });
});

app.get("/lowstock", (req, res) => {
  const search = req.query.search;

  let sql = `
    SELECT 
      ls.inventory_id,
      ls.status,
      inv.name,
      inv.category,
      inv.batch_number,
      inv.expiry_date,
      ls.quantity,
      ls.threshold
    FROM low_stock AS ls
    JOIN items_inventory AS inv 
      ON ls.inventory_id = inv.id
  `;

  const values = [];

  if (search && search.trim() !== "") {
    sql += " WHERE inv.name LIKE ?";
    values.push(`%${search}%`);
  }

  db.query(sql, values)
    .then((results) => {
      res.render("lowstock", {
        items: results,
        search: search,
      });
    })
    .catch((err) => res.status(500).send(err));
});

// Create a route for root - /
app.get("/expireditems", (req, res) => {
  const search = req.query.search;

  let sql = ` 
    SELECT 
      exi.inventory_id,
      inv.id,
      exi.status,
      inv.name,
      inv.category,
      inv.created_at,
      inv.batch_number,
      exi.expiry_date,
      inv.quantity,
      exi.days_left
    FROM expired_items AS exi
    JOIN items_inventory AS inv 
      ON exi.inventory_id = inv.id
  `;

  const values = [];

  if (search && search.trim() !== "") {
    sql += " WHERE inv.name LIKE ?";
    values.push(`%${search}%`);
  }

  db.query(sql, values)
    .then((results) => {
      res.render("expireditems", {
        items: results,
        search: search,
      });
    })
    .catch((err) => res.status(500).send(err));
});

app.get("/expiringitems", (req, res) => {
  const search = req.query.search;

  let sql = `
    SELECT 
      ex.inventory_id,
      inv.id,
      ex.status,
      inv.name,
      inv.category,
      inv.batch_number,
      ex.expiry_date,
      inv.quantity,
      ex.days_left,
      ex.created_at
    FROM expiring_soon AS ex
    JOIN items_inventory AS inv 
      ON ex.inventory_id = inv.id
  `;

  const values = [];

  if (search && search.trim() !== "") {
    sql += " WHERE inv.name LIKE ?";
    values.push(`%${search}%`);
  }

  db.query(sql, values)
    .then((results) => {
      res.render("expiringitems", {
        items: results,
        search: search,
      });
    })
    .catch((err) => res.status(500).send(err));
});

app.get("/addstock", (req, res) => {
  sql = "SELECT DISTINCT name, item_id FROM items_inventory";

  db.query(sql).then((results) => {
    res.render("addstock", { items: results });
  });
});

app.post("/addstock", async (req, res) => {
  const { item_id, quantity, supplier, batch_number, expiry_date } = req.body;
  var product = new Stock(item_id);
  await product.getStockName();
  await product.getStockCategory();
  await product.getStockThreshold();
  const category = product.category;
  const name = product.name;
  const low_stock_threshold = product.low_stock_threshold;
  console.log(req.body);

  const query = `INSERT INTO items_inventory (item_id, name, category, quantity,batch_number,low_stock_threshold, supplier, expiry_date) VALUES (?, ?, ?, ?, ?, ?,?,?)`;
  db.query(
    query,
    [
      item_id,
      name,
      category,
      quantity,
      batch_number,
      low_stock_threshold,
      supplier,
      expiry_date,
    ],
    (err, result) => {
      if (err) return res.status(500).send(err);
    },
    console.log("done"),
  );
});

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
  await product.getProductThreshold();
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

app.post("/updateinventoryquantity/:id", async (req, res) => {
  const id = req.params.id;
  const { quantity } = req.body;

  const sql = `UPDATE items_inventory SET quantity = ? WHERE id = ?`;

  await db.query(sql, [quantity, id], (err, result) => {
    if (err) {
      console.error(err);
      return res.send("Error updating quantity");
    }
    res.send("Quantity updated successfully");
  });
  res.redirect("back");
});

app.post("/updateinventorybatchNo/:id", (req, res) => {
  const id = req.params.id;
  const { batch_number } = req.body;

  const sql = `UPDATE items_inventory SET batch_number = ? WHERE id = ?`;

  db.query(sql, [batch_number, id], (err, result) => {
    if (err) {
      console.error(err);
      return res.send("Error updating batchnumber");
    }
    res.send("BatchNumber updated successfully");
  });
  res.redirect("back");
});

app.post("/updateinventoryexpiry/:id", (req, res) => {
  const id = req.params.id;
  const { expiry_date } = req.body;

  const sql = `UPDATE items_inventory SET expiry_date = ? WHERE id = ?`;

  db.query(sql, [expiry_date, id], (err, result) => {
    if (err) {
      console.error(err);
      return res.send("Error updating expirydate");
    }
    res.send("Expirydate updated successfully");
  });
  res.redirect("back");
});

app.post("/updateinventorysupplier/:id", (req, res) => {
  const id = req.params.id;
  const { supplier } = req.body;

  const sql = `UPDATE items_inventory SET supplier = ? WHERE id = ?`;

  db.query(sql, [supplier, id], (err, result) => {
    if (err) {
      console.error(err);
      return res.send("Error updating supplier");
    }
    res.send("Supplier updated successfully");
  });
  res.redirect("back");
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
