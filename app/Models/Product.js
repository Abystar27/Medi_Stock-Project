const db = require("../services/db");

class Product {
  // Student ID
  id;
  // Student name
  name;
  // Student programme of type Programme
  category;
  quantity;
  expiry;
  batch_no;
  supplier;
  created_at;
  updated_at;
  low_stock_threshold;
  // price;

  constructor(id) {
    this.id = id;
  }

  // Gets the student name from the database
  async getProductName() {
    var sql = "SELECT * from items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.name = results[0].name;
    // console.log(results);
  }

  // Gets the student name from the database
  async deleteProduct() {
    
    var sql = "DELETE FROM items_inventory WHERE id = ?";
    await db.query(sql, [this.id]);
    // console.log(results);
  }

 

  async getProductCategory() {
    var sql = "SELECT * from items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.category = results[0].category;
    // console.log(results);
  }

  async getProductQuantity() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.quantity = results[0].quantity;
    // console.log(results);
  }

  async getProductExpiry() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.expiry = results[0].expiry_date;
    // console.log(results);
  }

  async getProductBatchNo() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.batch_no = results[0].batch_number;
    // console.log(results);
  }

  async getProductSupplier() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.supplier = results[0].supplier;
    // console.log(results);
  }

  async getProductThreshold() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.low_stock_threshold = results[0].low_stock_threshold;
    // console.log(results);
  }

  async getCreatedDate() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.created_at = results[0].created_at;
    // console.log(results);
  }

  async getUpdatedDate() {
    var sql = "SELECT * FROM items_inventory where id = ?";
    const results = await db.query(sql, [this.id]);
    this.updated_at = results[0].updated_at;
    // console.log(results);
  }

  // async getProductPrice() {
  //   var sql = "SELECT * FROM inventory where item_id = ?";
  //   const results = await db.query(sql, [this.id]);
  //   this.price = results[0].PRICE;
  //   // console.log(results);
  // }
}

module.exports = {
  Product,
};
