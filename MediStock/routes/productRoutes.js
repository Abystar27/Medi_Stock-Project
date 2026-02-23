const express = require("express");
const router = express.Router();
const fs = require("fs");
const path = require("path");

// Add Product Route
router.post("/add", (req, res) => {
  const filePath = path.join(__dirname, "../inventory.json");

  const data = fs.readFileSync(filePath, "utf8");
  const products = JSON.parse(data);

  const batchNumber = `B${String(products.length + 1).padStart(3, "0")}`;
  const newProduct = {
    id: products.length + 1,
    batchNumber,
    ...req.body,
  };
  products.push(newProduct);

  fs.writeFileSync(filePath, JSON.stringify(products, null, 2));

  res.status(201).json(newProduct);
});
console.log(newProduct);

// Optional: Get all products
router.get("/", (req, res) => {
  const filePath = path.join(__dirname, "../inventory.json");
  const data = fs.readFileSync(filePath, "utf8");
  const products = JSON.parse(data);
  res.json(products);
});

module.exports = router;
