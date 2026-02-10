let email = document.getElementById("email");
let password = document.getElementById("password");
let submit = document.getElementById("submit");
let error = document.getElementById("error");

submit.addEventListener("click", (e) => {
  e.preventDefault();
  if (email.value.trim() === "" || password.value.trim() === "") {
    error.style.display = "block";
    console.log("done");
  } else {
    console.log("qsbx");
    error.style.display = "none";
    window.location.href = "dashboard.html";
  }
});
