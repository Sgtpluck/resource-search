// const handleAll = (all_id, input_class) => {
//   const all = document.getElementById(
// }
const chooseTypeAll = document.getElementById("search_query_type_All");
const typeInputArray = Array.from(document.getElementsByClassName("type"));
chooseTypeAll.addEventListener('click', (event) => {
  if (event.target.value === "1") {
    typeInputArray.forEach(input => {
      input.checked = 0;
    });
  }
});

typeInputArray.forEach(input => {
  input.addEventListener("click", () => {
    chooseTypeAll.checked = false; 
  })
})


const chooseSourceAll = document.getElementById("search_source_All");
const sourceInputArray = Array.from(document.getElementsByClassName("source"));
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