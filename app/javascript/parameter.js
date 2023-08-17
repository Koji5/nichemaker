window.addEventListener('load', parameterInit);

function parameterInit(){
  const parameterInput = document.getElementById("parameter_name_input");
  if (parameterInput != null){
    setParameter();
    return;
  }
}

function setParameter(){
  const addButton = document.getElementById('add_parameter');
  const parameterList = document.getElementById('parameter_list');
  const nicheId = document.getElementById("niche_id").value;

  // 新規作成
  addButton.addEventListener('click', () => {
    const nameInputField = document.getElementById('parameter_name_input');
    const unitInputField = document.getElementById('parameter_unit_input');
    const parameterName = nameInputField.value;
    const parameterUnit = unitInputField.value;
    // ajax処理
    const url = '/' + nicheId + '/niche_parameters';
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
    const data = JSON.stringify({
      niche_parameter: {
        name: parameterName,
        unit: parameterUnit,
        niche_id: nicheId
      }
    });
    xhr.onload = function() {
      nameInputField.value = '';
      unitInputField.value = '';
      ajaxOnLoad(xhr);
    };
    xhr.send(data);
  });

  // 編集・削除
  parameterList.addEventListener('click', (event) => {
    const listItem = event.target.closest('li');
    const parameterId = listItem.getAttribute('data-id');
    if (event.target.classList.contains('parameter_edit')) {
      // 編集
      const inputFields = listItem.querySelectorAll('input');
      const firstInputField = inputFields[0]; 
      const secondInputField = inputFields[1];
      const newName = firstInputField.value;
      const newUnit = secondInputField.value;
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/' + nicheId + '/niche_parameters/' + parameterId;
      xhr.open('PUT', url, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      const data = JSON.stringify({
        niche_parameter: {
          name: newName,
          unit: newUnit
        }
      });
      xhr.onload = function() {
        ajaxOnLoad(xhr);
      };
      xhr.send(data);
    } else if (event.target.classList.contains('parameter_delete')) {
      // 削除
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/' + nicheId + '/niche_parameters/' + parameterId;
      xhr.open('DELETE', url, true);
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      xhr.onload = function() {
        ajaxOnLoad(xhr);
      };
      xhr.send();
    }
  });
}

function reRenderParameter(responseData){
  const parameterList = document.getElementById('parameter_list');
  while (parameterList.firstChild) {
    parameterList.removeChild(parameterList.firstChild);
  }
  responseData.forEach(function(parameter) {
    const listItem = document.createElement('li'); // 新たに<li>要素を作成
    listItem.dataset.id = parameter.id;
    listItem.innerHTML = `
      <input type="text" value="${parameter.name}">
      <input type="text" value="${parameter.unit}">
      <button class="parameter_edit">編集</button>
      <button class="parameter_delete">削除</button>
    `;
    parameterList.appendChild(listItem);
  });
}

function ajaxOnLoad(xhr){
  if (xhr.status === 200) {
    const responseData = JSON.parse(xhr.responseText);
    reRenderParameter(responseData);
  } else if (xhr.status === 422) {
    const errors = JSON.parse(xhr.responseText);
    let errorMessage = "変更できませんでした。\n";
    for (const field in errors) {
      errorMessage += `${field}: ${errors[field].join(", ")}\n`;
    }
    alert(errorMessage);
  } else {
    console.error('Error:', xhr.status, xhr.statusText);
  }
}

function getCSRFToken() {
  const tokenTag = document.querySelector('meta[name="csrf-token"]');
  return tokenTag ? tokenTag.content : '';
}
