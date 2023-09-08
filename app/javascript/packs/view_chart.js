import Chart from 'chart.js/auto';

document.addEventListener("DOMContentLoaded", function() {
  const ctx = document.getElementById('myChart');

  new Chart(ctx, {
    type: 'line',
    data: {
      labels: ['2023/8/9', '2023/8/10', '2023/8/11', '2023/8/12', '2023/8/13'],
      datasets: [
      {
        label: 'HP',
        data: [30, 50, 70, 85, 100],
        borderWidth: 1
      } , {
        label: 'EN',
        data: [15, 30, 55, 75, 85],
        borderWidth: 1
 
      } , {
        label: '装甲値',
        data: [40, 52, 63, 78, 100],
        borderWidth: 1
 
      } , {
        label: '運動性',
        data: [20, 35, 42, 58, 75],
        borderWidth: 1
 
      } , {
        label: '照準値',
        data: [20, 38, 52, 78, 85],
        borderWidth: 1
 
      } , {
        label: '武器',
        data: [10, 25, 65, 78, 99],
        borderWidth: 1
 
      }
    ]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  });
});
