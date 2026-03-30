const db = require("../services/db");

class Stock {
  id;
  name;
  category;
  low_stock_threshold;

  constructor(id) {
    this.id = id;
  }

  // Gets the student name from the database
  async getStockName() {
    var sql = "SELECT * from items_inventory where item_id = ?";
    const results = await db.query(sql, [this.id]);
    this.name = results[0].name;
    // console.log(results);
  }

  async getStockCategory() {
    var sql = "SELECT * from items_inventory where item_id = ?";
    const results = await db.query(sql, [this.id]);
    this.category = results[0].category;
    // console.log(results);
  }

  async getStockThreshold() {
    var sql = "SELECT * FROM items_inventory where item_id = ?";
    const results = await db.query(sql, [this.id]);
    this.low_stock_threshold = results[0].low_stock_threshold;
    // console.log(results);
  }

  async getNextItemid() {
    var sql = `SELECT MAX(item_id) as maxId FROM items_inventory`;
    const results = await db.query(sql);
    console.log(results);
    const maxId = results[0].maxId;
    console.log(maxId);
    this.item_id = parseInt(maxId + 1);
  }
}

module.exports = {
  Stock,
};
