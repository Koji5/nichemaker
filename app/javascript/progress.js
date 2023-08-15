window.addEventListener('load', progressInit);

function progressInit(){
  const progressSelect = document.getElementById("niche_progress_group_select");
  if (progressSelect != null){
    setProgress();
    return;
  }
  const progressInput = document.getElementById("progress_group_input");
  if (progressInput != null){
    saveProgressGroup();
    saveProgressTask();
    return;
  }
}

// 進捗タスク
function saveProgressTask(){
  const addButton = document.getElementById('add_progress_task');
  const inputField = document.getElementById('progress_task_input');
  const selectField = document.getElementById('niche_progress_group_id');
  const progressTaskList = document.getElementById('progress_task_list');

  const nicheId = document.getElementById("niche_id").value;

  // 新規作成
  addButton.addEventListener('click', () => {
    const progressTaskName = inputField.value;
    const progressGroupId = selectField.value;
    // ajax処理
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/niche_progress_tasks', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
    const data = JSON.stringify({
      niche_progress_task: {
        name: progressTaskName,
        niche_progress_group_id: progressGroupId,
        niche_id: nicheId
      }
    });
    xhr.onload = function() {
      if (xhr.status === 200) {
        const responseData = JSON.parse(xhr.responseText);
          reRenderProgressTask(responseData);
          inputField.value = '';
      } else if (xhr.status === 422) {
        const errors = JSON.parse(xhr.responseText);
        let errorMessage = "作成できませんでした。\n";
        for (const field in errors) {
          errorMessage += `${field}: ${errors[field].join(", ")}\n`;
        }
        alert(errorMessage);
      } else {
        console.error('Error:', xhr.status, xhr.statusText);
      }
    };
    xhr.send(data);
  });

  // 編集・削除ボタン
  progressTaskList.addEventListener('click', (event) => {
    const listItem = event.target.closest('li');
    const progressTaskId = listItem.getAttribute('data-id');
    // 編集
    if (event.target.classList.contains('progress_task_edit')) {
      const listInputField = listItem.querySelector('input');
      const newName = listInputField.value;
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/niche_progress_tasks/' + progressTaskId
      xhr.open('PUT', url, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      const data = JSON.stringify({
        niche_progress_task: {
          name: newName,
          niche_id: nicheId
        }
      });
      xhr.onload = function() {
        if (xhr.status === 200) {
          const responseData = JSON.parse(xhr.responseText);
          reRenderProgressTask(responseData);
        } else if (xhr.status === 422) {
          const errors = JSON.parse(xhr.responseText);
          let errorMessage = "編集できませんでした。\n";
          for (const field in errors) {
            errorMessage += `${field}: ${errors[field].join(", ")}\n`;
          }
          alert(errorMessage);
        } else {
          console.error('Error:', xhr.status, xhr.statusText);
        }
      };
      xhr.send(data);
  
    // 削除
    } else if (event.target.classList.contains('progress_task_delete')) {
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/niche_progress_tasks/' + progressTaskId
      xhr.open('DELETE', url, true);
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      const data = JSON.stringify({
        niche_progress_task: {
          niche_id: nicheId
        }
      });
      xhr.onload = function() {
        if (xhr.status === 200) {
          const responseData = JSON.parse(xhr.responseText);
          reRenderProgressTask(responseData);
        } else if (xhr.status === 422) {
          const errors = JSON.parse(xhr.responseText);
          let errorMessage = "削除できませんでした。\n";
          for (const field in errors) {
            errorMessage += `${field}: ${errors[field].join(", ")}\n`;
          }
          alert(errorMessage);
        } else {
          console.error('Error:', xhr.status, xhr.statusText);
        }
      };
      xhr.send(data);
    }
  });
}

// 進捗グループ
function saveProgressGroup(){
  const addButton = document.getElementById('add_progress_group');
  const inputField = document.getElementById('progress_group_input');
  const progressGroupList = document.getElementById('progress_group_list');
  const nicheId = document.getElementById("niche_id").value;

  // 新規作成
  addButton.addEventListener('click', () => {
    const progressGroupName = inputField.value;

    // ajax処理
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/niche_progress_groups', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
    const data = JSON.stringify({
      niche_progress_group: {
        name: progressGroupName,
        niche_id: nicheId
      }
    });
    xhr.onload = function() {
      if (xhr.status === 200) {
        const responseData = JSON.parse(xhr.responseText);
        const listItem = document.createElement('li');
        listItem.dataset.id = responseData.id;
        listItem.innerHTML = `
          <input type="text" value="${progressGroupName}">
          <button class="progress_group_edit">編集</button>
          <button class="progress_group_delete">削除</button>
        `;
        requestAnimationFrame(() => {
         progressGroupList.appendChild(listItem);
          inputField.value = '';
          alert("追加しました");
          window.location.href = "/" + nicheId + "/edit";
        });
      } else if (xhr.status === 422) {
        const errors = JSON.parse(xhr.responseText);
        let errorMessage = "作成できませんでした。\n";
        for (const field in errors) {
          errorMessage += `${field}: ${errors[field].join(", ")}\n`;
        }
        alert(errorMessage);
    } else {
        console.error('Error:', xhr.status, xhr.statusText);
      }
    };
    xhr.send(data);
  });

  progressGroupList.addEventListener('click', (event) => {
  // 編集
    if (event.target.classList.contains('progress_group_edit')) {
      const listItem = event.target.closest('li');
      const listInputField = listItem.querySelector('input');
      const newName = listInputField.value;
      const progressGroupId = listItem.getAttribute('data-id');

      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/niche_progress_groups/' + progressGroupId
      xhr.open('PUT', url, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      const data = JSON.stringify({
        niche_progress_group: { name: newName }
      });
      xhr.onload = function() {
        if (xhr.status === 200) {
          const responseData = JSON.parse(xhr.responseText);
          alert(responseData.message);
          window.location.href = "/" + nicheId + "/edit";
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
      };
      xhr.send(data);
  // 削除
    } else if (event.target.classList.contains('progress_group_delete')) {
      const listItem = event.target.closest('li');
      const progressGroupId = listItem.getAttribute('data-id');
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/niche_progress_groups/' + progressGroupId
      xhr.open('DELETE', url, true);
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      xhr.onload = function() {
        if (xhr.status === 200) {
          const responseData = JSON.parse(xhr.responseText);
          alert(responseData.message);
          window.location.href = "/" + nicheId + "/edit";
          //requestAnimationFrame(() => {
          //  event.target.parentNode.remove();
          //});
        } else if (xhr.status === 422) {
          const errors = JSON.parse(xhr.responseText);
          let errorMessage = "削除できませんでした。\n";
          for (const field in errors) {
            errorMessage += `${field}: ${errors[field].join(", ")}\n`;
          }
          alert(errorMessage);
        } else {
          console.error('Error:', xhr.status, xhr.statusText);
        }
      };
      xhr.send();
    }
  });
}

function reRenderProgressTask(responseData) {
  const progressTaskList = document.getElementById('progress_task_list');
  while (progressTaskList.firstChild) {
    progressTaskList.removeChild(progressTaskList.firstChild);
  }

  responseData.forEach(function(task) {
    const listItem = document.createElement('li'); // 新たに<li>要素を作成
    listItem.dataset.id = task.id;
    listItem.innerHTML = `
      ${task.niche_progress_group.name}
      <input type="text" value="${task.name}">
      <button class="progress_task_edit">編集</button>
      <button class="progress_task_delete">削除</button>
    `;

    requestAnimationFrame(() => {
      progressTaskList.appendChild(listItem);
    });
  });
}

function getCSRFToken() {
  const tokenTag = document.querySelector('meta[name="csrf-token"]');
  return tokenTag ? tokenTag.content : '';
}

//記事投稿画面で使用
function setProgress(){
  const progressSelect = document.getElementById("niche_progress_group_select");
  progressSelect.addEventListener('change', () => {
    const selectedNicheProgressGroupId = progressSelect.value;
    // ajax処理
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/fetch_niche_progress_tasks', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
    const data = JSON.stringify({
      niche_progress_group_id: selectedNicheProgressGroupId
    });
    xhr.onload = function() {
      if (xhr.status === 200) {
        const taskSelect = document.getElementById("niche_progress_task_select");
        taskSelect.innerHTML = ''; // 子要素をクリア

        const response = JSON.parse(xhr.responseText);
        response.forEach(function(task) {
          const option = document.createElement("option");
          option.value = task.id;
          option.text = task.name;
          taskSelect.appendChild(option);
        });
      } else {
        console.error('Error:', xhr.status, xhr.statusText);
      }
    };
    xhr.send(data);
  });

  const selectElement = document.getElementById("niche_progress_task_select");
  const hiddenField = document.getElementById("selected_niche_progress_task_id");
  
  selectElement.addEventListener("change", function() {
    const selectedValue = selectElement.value;
    hiddenField.value = selectedValue;
  });
};