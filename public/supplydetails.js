//navigate button
const back = document.getElementById("back");
if (back) {
  back.addEventListener("click", (e) => {
    window.history.back();
  });
}

const button = document.getElementById("update");
const forms = document.querySelectorAll(".Qform");
button.addEventListener("click", () => {
  forms.forEach((form) => {
    form.style.display = "block";
  });
});
