import Chart from 'chart.js/auto';

document.addEventListener("DOMContentLoaded", function() {
  const ctx = document.getElementById('myChart');

  new Chart(ctx, {
    type: 'line',
    data: {
      labels: ['2023/8/9', '2023/8/10', '2023/8/11', '2023/8/12', '2023/8/13', '2023/8/14'],
      datasets: [
      {
        label: '攻撃力',
        data: [1, 3, 5, 6, 9, 10],
        borderWidth: 1
      } , {
        label: '防御力',
        data: [2, 3, 4, 5, 7, 10],
        borderWidth: 1
 
      } , {
        label: '俊敏',
        data: [0, 1, 2, 10, 11, 11],
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
