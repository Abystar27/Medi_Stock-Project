const menuBtn = document.getElementById("menu");
const mobileNav = document.querySelector(".mobilenav");
menuBtn.addEventListener("click", () => {
  console.log("menu");
  mobileNav.classList.toggle("open");
});

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
      // window.location.href = "/dashboard";
    }
  });
}
