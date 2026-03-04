function displaySupplydetails() {
  const params = new URLSearchParams(window.location.search);
  const id = parseInt(params.get("id"));
  console.log(id);

  fetch("inventory.json")
    .then((res) => res.json())
    .then((items) => {
      const selectedSupply = items.find((item) => item.id === id);

      if (selectedSupply) {
        document.getElementById("name").textContent = selectedSupply.name;
        document.getElementById("category").textContent =
          selectedSupply.category;
        document.getElementById("quantity").textContent =
          selectedSupply.quantity;
        document.getElementById("batch").textContent =
          selectedSupply.batchNumber;
        document.getElementById("expiry").textContent =
          selectedSupply.expiryDate;
      }
    })
    .catch((err) => console.error(err));
}

document.addEventListener("DOMContentLoaded", displaySupplydetails);

//navigate button
const back = document.getElementById("back");
if (back) {
  back.addEventListener("click", (e) => {
    window.history.back();
  });
}
