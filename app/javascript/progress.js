window.addEventListener('load', setProgress);

function setProgress(){
  $('#niche_progress_group_select').change(function() {
    var selectedNicheProgressGroupId = $(this).val();

    $.ajax({
      url: '/fetch_niche_progress_tasks',
      method: 'GET',
      data: { niche_progress_group_id: selectedNicheProgressGroupId },
      success: function(response) {
        var taskSelect = $('#niche_progress_task_select');
        taskSelect.empty();

        response.forEach(function(task) {
          taskSelect.append($('<option>', {
            value: task.id,
            text: task.name
          }));
        });
      }
    });
  });

  const selectElement = document.getElementById("niche_progress_task_select");
  const hiddenField = document.getElementById("selected_niche_progress_task_id");
  
  selectElement.addEventListener("change", function() {
    const selectedValue = selectElement.value;
    hiddenField.value = selectedValue;
  });
};