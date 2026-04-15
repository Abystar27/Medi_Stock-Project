// Get the functions in the db.js file to use
const db = require("../services/db");
const bcrypt = require("bcryptjs");

class user {
  // Id of the user
  id;

  // Email of the user
  email;

  constructor(email) {
    this.email = email;
  }

  // Get an existing user id from an email address, or return false if not found
  async getIdFromEmail() {
    var sql = "SELECT user_id FROM users WHERE users.email = ?";
    const result = await db.query(sql, [this.email]);
    if (JSON.stringify(result) != "[]") {
      this.id = result[0].user_id;
      return this.id;
    } else {
      return false;
    }
  }

  // Add a password to an existing user
  async setUserPassword(password) {
    const pw = await bcrypt.hash(password, 10);
    var sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
    const result = await db.query(sql, [pw, this.id]);
    return true;
  }

  // Add a new record to the users table
  async addUser(password) {
    const pw = await bcrypt.hash(password, 10);
    const sql = `
    INSERT INTO users (email, password_hash, name, role)
    VALUES (?, ?, ?, ?)
  `;

    const result = await db.query(sql, [
      this.email,
      pw,
      this.username,
      this.role,
    ]);
    console.log(result.insertId);
    this.id = result.insertId;
    return true;
  }

  // Test a submitted password against a stored password
  async authenticate(submitted) {
    var sql = "SELECT password_hash FROM users WHERE user_id = ?";
    const result = await db.query(sql, [this.id]);
    const match = await bcrypt.compare(submitted, result[0].password_hash);
    if (match == true) {
      return true;
    } else {
      return false;
    }
  }
}

module.exports = {
  user,
};
