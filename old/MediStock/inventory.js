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
      renderInventory(data);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
});

// Filter all inventory
const filter = document.getElementById("categoryFilter");
if (filter) {
  filter.addEventListener("change", () => {
    const selectedValue = filter.value;
    console.log("Selected category:", selectedValue);
    filterInventory(selectedValue);
  });
}

function filterInventory(category) {
  let filteredItems = items; // items = your current inventory array
  if (category !== "all") {
    filteredItems = items.filter((item) => item.category === category);
  }
  renderInventory(filteredItems); // re-render table with filtered data
}

//search
const search = document.getElementById("inventorySearch");
if (search) {
  search.addEventListener("input", () => {
    const searchInput = search.value.trim().toLowerCase();
    let result = items;
    result = items.filter((item) =>
      item.name.trim().toLowerCase().includes(searchInput),
    );
    renderInventory(result);
  });
}

//display inventory
function renderInventory(items) {
  const tableBody = document.getElementById("inventorybody");
  if (!tableBody) return;
  tableBody.innerHTML = "";

  items.forEach((item) => {
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
    row.addEventListener("click", () => {
      window.location.href = `supplyDetails.html?id=${item.id}`;v
    });
    tableBody.appendChild(row);
  });
  colorStatusButtons();
}


//color button
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

//navigate button
const back = document.getElementById("back");
if (back) {
  back.addEventListener("click", (e) => {
    window.history.back();
  });
}
