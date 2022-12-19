const handleAll = (allId, inputClass) => {
  const all = document.getElementById(allId);
  const inputArray = Array.from(document.getElementsByClassName(inputClass));

  all.addEventListener('click', (event) => {
    if (event.target.value === "1") {
      inputArray.forEach(input => {
        input.checked = 0;
      });
    }
  });

  inputArray.forEach(input => {
    input.addEventListener("click", () => {
      all.checked = false; 
    })
  })
}

handleAll("search_query_type_All", "type");
handleAll("search_source_All", "source")
