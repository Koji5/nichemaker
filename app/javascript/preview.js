document.addEventListener("DOMContentLoaded", function() {
  if (document.getElementById("add-image-button") == null){
    return;
  }
  const fileField = document.querySelector('input[type="file"]');
  const imageDisplayArea = document.getElementById('image-display-area');
  const addButton = document.getElementById('add-image-button');
  const deletedImages = document.getElementById('deleted-images');

  const displayImage = (filename, blob, imageId = null) => {
      const container = document.createElement('div');
      if (imageId) container.dataset.imageId = imageId;

      const previewImage = document.createElement('img');
      previewImage.src = blob;
      
      const fileNameDisplay = document.createElement('span');
      fileNameDisplay.textContent = filename;

      const deleteButton = document.createElement('button');
      deleteButton.textContent = "削除";
      deleteButton.classList.add("delete-button");

      deleteButton.onclick = () => {
          imageDisplayArea.removeChild(container);
          if (imageId) {
              const input = document.createElement('input');
              input.type = 'hidden';
              input.name = 'deleted_image_ids[]';
              input.value = imageId;
              deletedImages.appendChild(input);
          }
      };
      let imageWrapper = document.createElement("div");
      imageWrapper.className = "image-wrapper";

      imageWrapper.appendChild(previewImage);
      imageWrapper.appendChild(fileNameDisplay);
      imageWrapper.appendChild(deleteButton);
      container.appendChild(imageWrapper);
      imageDisplayArea.appendChild(container);
  };

  fileField.addEventListener('change', function(e) {
      if (e.target.files.length > 0) {
          Array.from(e.target.files).forEach(file => {
              const blob = URL.createObjectURL(file);
              displayImage(file.name, blob);
          });
      }
  });

  addButton.addEventListener('click', () => {
      fileField.click();
  });

  if (typeof attachedImagesData !== 'undefined') {
      attachedImagesData.forEach(data => {
          displayImage(data.filename, data.url, data.id);
      });
  }
});
