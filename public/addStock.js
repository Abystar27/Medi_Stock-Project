// const form = document.getElementById("addStockForm");
// const message = document.getElementById("message");

// form.addEventListener("submit", async (e) => {
//   e.preventDefault();
//   console.log("Submitted");
//   const productData = {
//     name: document.getElementById("name").value,
//     category: document.getElementById("category").value,
//     quantity: Number(document.getElementById("quantity").value),
//     price: Number(document.getElementById("price").value),
//     expiryDate: document.getElementById("expiryDate").value,
//   };

//   try {
//     const response = await fetch("http://localhost:5000/api/products/add", {
//       method: "POST",
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: JSON.stringify(productData),
//     });

//     const data = await response.json();

//     if (!response.ok) {
//       throw new Error(data.message || "Failed to add product");
//     }

//     message.style.color = "green";
//     message.textContent = "Product added successfully!";

//     form.reset();
//   } catch (error) {
//     message.style.color = "red";
//     message.textContent = error.message;
//   }
// });
const message = document.getElementById("message");
const form = document.getElementById("addStockForm");

form.addEventListener("submit", async (e) => {
  console.log("js clicked");
  message.style.display = "block";

  setTimeout(() => {
    message.style.display = "none";
    window.location.reload();
  }, 2000);
});

//navigate button
const back = document.getElementById("backs");
if (back) {
  back.addEventListener("click", (e) => {
    window.history.back();
  });
}
