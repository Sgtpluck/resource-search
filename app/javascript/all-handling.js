console.log("hi")

const chooseSourceAll = document.getElementById("search_source_All");
const sourceInputs = document.getElementsByClassName("source");
const sourceInputArray = Array.from(sourceInputs)

chooseSourceAll.addEventListener('click', (event) => {
  if (event.target.value === "1") {
    sourceInputArray.forEach(input => {
      input.checked = 0;
    });
  }
});

sourceInputArray.forEach(input => {
  input.addEventListener("click", () => {
    chooseSourceAll.checked = false; 
  })
})