let email = document.getElementById("email");
let password = document.getElementById("password");
let error = document.getElementById("error");
let totalStock = document.getElementById("totalStock");

let items = [];
document.addEventListener("DOMContentLoaded", () => {
  fetch("inventory.json")
    .then((response) => {
      if (!response.ok) {
        throw new Error("Failed to load JSON");
      }
      return response.json();
    })
    .then((data) => {
      items = data;
      renderExpiredItems(data);
      renderLowstock(data);
      updateCount(data);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
});

// Filter all lowstock
const LSfilter = document.getElementById("LSFilter");
if (LSfilter) {
  LSfilter.addEventListener("change", () => {
    const selectedValue = LSfilter.value;
    filterLowStock(selectedValue);
  });
}

function filterLowStock(category) {
  let filteredItems = items; // items = your current inventory array
  if (category !== "all") {
    filteredItems = items.filter((item) => item.category === category);
  }
  renderLowstock(filteredItems, category); // re-render table with filtered data
}

//search
const search = document.getElementById("lowstocksearch");
if (search) {
  search.addEventListener("input", () => {
    const searchInput = search.value.trim().toLowerCase();
    let result = items;
    result = items.filter((item) =>
      item.name.trim().toLowerCase().includes(searchInput),
    );
    renderLowstock(result);
  });
}

//render the low stock list
function renderLowstock(items, category) {
  const tableBody1 = document.getElementById("lowstockbody");
  const count = document.getElementById("lowStockcount");
  if (!tableBody1) return;
  tableBody1.innerHTML = "";

  newItems = items.filter((item) => item.quantity <= 20);
  console.log(newItems.length);
  newItems.length === 0
    ? ((tableBody1.innerHTML = `No ${category} is in Low Stock`),
      (count.style.color = "red"),
      ((tableBody1.style.color = "white"),
      (tableBody1.style.fontSize = "1.2rem"),
      (tableBody1.style.padding = "20rem"),
      (tableBody1.style.width = "100%")))
    : newItems.forEach((item) => {
        const row = document.createElement("tr");
        const status =
          item.quantity === 0
            ? "Out of Stock"
            : item.quantity <= 20
              ? "Low Stock"
              : "In Stock";

        row.innerHTML = `
      <td>${item.name}</td>
      <td>${item.category}</td>
      <td>${item.quantity}</td>
      <td>${item.batchNumber}</td>
      <td>${item.expiryDate}</td>
      <td>
      <button class="Button">
      ${status}</button></td>
      <td>
        <button class="edit-btn" data-id="${item.id}">Edit</button>
        <button class="delete-btn" data-id="${item.id}">Delete</button>
      </td>
    `;
        tableBody1.appendChild(row);
      });
  colorStatusButtons();
}

//display count
function updateCount(items) {
  const lowStockItems = items.filter((item) => item.quantity <= 20);

  const element = document.getElementById("lowStockcount");
  const totalSTockcount = document.getElementById("totalStock");
  const expiredItem = document.getElementById("expireditem");

  if (!element) return;
  if (!totalSTockcount) return;
  function getCurrentDate() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, "0");
    const day = String(now.getDate()).padStart(2, "0");

    return `${year}-${month}-${day}`;
  }
  let date = getCurrentDate();
  newList = items.filter((item) => item.expiryDate <= date);

  element.textContent = lowStockItems.length;
  totalSTockcount.textContent = items.length;
  expiredItem.textContent = newList.length;
}

function colorStatusButtons() {
  const buttons = document.querySelectorAll(".Button");
  buttons.forEach((btn) => {
    const status = btn.textContent.trim();

    if (status === "In Stock") {
      btn.style.backgroundColor = "#27ae60";
      btn.style.color = "white";
    } else if (status === "Low Stock") {
      btn.style.backgroundColor = "pink";
      btn.style.color = "black";
    } else if (status === "Out of Stock") {
      btn.style.backgroundColor = "#ad3737";
      btn.style.color = "white";
    }
    btn.style.border = "none";
    btn.style.padding = "5px 10px";
    btn.style.borderRadius = "5px";
    btn.style.cursor = "default";
  });
}

function renderExpiredItems(items) {
  expiredTable = document.getElementById("expiredItems");
  if (!expiredTable) return;
  expiredTable.innerHTML = "";
  // console.log("Expired");
  function getCurrentDate() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, "0");
    const day = String(now.getDate()).padStart(2, "0");

    return `${year}-${month}-${day}`;
  }

  console.log(getCurrentDate());

  let date = getCurrentDate();
  console.log(date);
  newList = items.filter((item) => item.expiryDate <= date);
  console.log(newList);

  newList.forEach((item) => {
    const row = document.createElement("tr");
    const status =
      item.quantity === 0
        ? "Out of Stock"
        : item.quantity <= 20
          ? "Low Stock"
          : "In Stock";

    row.innerHTML = `
      <td>${item.name}</td>
      <td>${item.category}</td>
      <td>${item.quantity}</td>
      <td>${item.batchNumber}</td>
      <td>${item.expiryDate}</td>
      <td>
      <button class="Button">
      ${status}</button></td>
      <td>
      <button class="edit-btn" data-id="${item.id}">Edit</button>
      <button class="delete-btn" data-id="${item.id}">Delete</button>
      </td>
      `;
    expiredTable.appendChild(row);
  });
  colorStatusButtons();
}

//navigate button
const back = document.getElementById("back");
if (back)
  back.addEventListener("click", (e) => {
    window.history.back();
  });

//login authentication
let submit = document.getElementById("submit");
if (submit) {
  submit.addEventListener("click", (e) => {
    e.preventDefault();
    if (email.value.trim() === "" || password.value.trim() === "") {
      error.style.display = "block";
      console.log("done");
    } else {
      console.log("qsbx");
      error.style.display = "none";
      window.location.href = "/dashboard";
    }
  });
}
