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
    const progressGroupId = selectField.value;
    const progressTaskName = inputField.value;
    // ajax処理
    const url = '/' + nicheId + '/niche_progress_groups/' + progressGroupId + '/niche_progress_tasks';
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
    const data = JSON.stringify({
      niche_progress_task: {
        name: progressTaskName,
        niche_progress_group_id: progressGroupId
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
    const progressGroupId = selectField.value;
    // 編集
    if (event.target.classList.contains('progress_task_edit')) {
      const listInputField = listItem.querySelector('input');
      const newName = listInputField.value;
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/' + nicheId + '/niche_progress_groups/' + progressGroupId + '/niche_progress_tasks/' + progressTaskId;
      xhr.open('PUT', url, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      const data = JSON.stringify({
        niche_progress_task: {
          name: newName
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
      const url = '/' + nicheId + '/niche_progress_groups/' + progressGroupId + '/niche_progress_tasks/' + progressTaskId;
      xhr.open('DELETE', url, true);
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
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
      xhr.send();
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
    const url = '/' + nicheId + '/niche_progress_groups';
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
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
        reRenderProgressGroup(responseData.niche_progress_groups);
        reRenderProgressTask(responseData.niche_progress_tasks);
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

  // 編集・削除
  progressGroupList.addEventListener('click', (event) => {
    const listItem = event.target.closest('li');
    const progressGroupId = listItem.getAttribute('data-id');
    // 編集
    if (event.target.classList.contains('progress_group_edit')) {
      const listInputField = listItem.querySelector('input');
      const newName = listInputField.value;
      // ajax処理
      const url = '/' + nicheId + '/niche_progress_groups/' + progressGroupId;
      const xhr = new XMLHttpRequest();
      xhr.open('PUT', url, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      const data = JSON.stringify({
        niche_progress_group: { name: newName }
      });
      xhr.onload = function() {
        if (xhr.status === 200) {
          const responseData = JSON.parse(xhr.responseText);
          reRenderProgressGroup(responseData.niche_progress_groups);
          reRenderProgressTask(responseData.niche_progress_tasks);
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
      // ajax処理
      const xhr = new XMLHttpRequest();
      const url = '/' + nicheId + '/niche_progress_groups/' + progressGroupId;
      xhr.open('DELETE', url, true);
      xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
      xhr.onload = function() {
        if (xhr.status === 200) {
          const responseData = JSON.parse(xhr.responseText);
          reRenderProgressGroup(responseData.niche_progress_groups);
          reRenderProgressTask(responseData.niche_progress_tasks);
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

// 進捗グループ変更時のレンダリング
function reRenderProgressGroup(responseData) {
  const progressGroutSelect = document.getElementById('niche_progress_group_id');
  const progressGroupList = document.getElementById('progress_group_list');
  while (progressGroutSelect.firstChild) {
    progressGroutSelect.removeChild(progressGroutSelect.firstChild);
  }
  while (progressGroupList.firstChild) {
    progressGroupList.removeChild(progressGroupList.firstChild);
  }
  responseData.forEach(function(group) {
    const listItem = document.createElement('li'); // 新たに<li>要素を作成
    listItem.dataset.id = group.id;
    listItem.innerHTML = `
      <input type="text" value="${group.name}">
      <button class="progress_group_edit">編集</button>
      <button class="progress_group_delete">削除</button>
    `;
    const selectItem = document.createElement('option');
    selectItem.value = group.id;
    selectItem.innerHTML = `${group.name}`;
    // 要素に追加
    progressGroupList.appendChild(listItem);
    progressGroutSelect.appendChild(selectItem);
  });
}

// 進捗タスク変更時のレンダリング
function reRenderProgressTask(responseData) {
  const progressTaskList = document.getElementById('progress_task_list');
  while (progressTaskList.firstChild) {
    progressTaskList.removeChild(progressTaskList.firstChild);
  }
  responseData.forEach(function(task) {
    const listItem = document.createElement('li'); // 新たに<li>要素を作成
    listItem.dataset.id = task.id;
    listItem.innerHTML = `
      ${task.group_name}
      <input type="text" value="${task.name}">
      <button class="progress_task_edit">編集</button>
      <button class="progress_task_delete">削除</button>
    `;
    progressTaskList.appendChild(listItem);
  });
}

function getCSRFToken() {
  const tokenTag = document.querySelector('meta[name="csrf-token"]');
  return tokenTag ? tokenTag.content : '';
}

//記事投稿画面で使用
function setProgress(){
  const progressSelect = document.getElementById("niche_progress_group_select");
  const nicheId = document.getElementById("niche_id").value;
  progressSelect.addEventListener('change', () => {
    const selectedNicheProgressGroupId = progressSelect.value;
    // ajax処理
    const url = '/' + nicheId + '/niche_progress_groups/' + selectedNicheProgressGroupId + '/fetch_niche_progress_tasks/';
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', getCSRFToken()); // 必要に応じてCSRFトークンを取得
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
    xhr.send();
  });
};