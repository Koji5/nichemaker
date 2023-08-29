import Gantt from 'frappe-gantt';

document.addEventListener("DOMContentLoaded", function() {
  var tasks = [
    {
      id: 'Task 1',
      name: 'Task 1',
      start: '2023-8-1',
      end: '2023-8-31',
      progress: 50,
      dependencies: ''
    },
    {
      id: 'Task 2',
      name: 'Task 1 - Task 2',
      start: '2023-8-1',
      end: '2023-8-10',
      progress: 100,
      dependencies: ''
    },
    {
      id: 'Task 3',
      name: 'Task 1 - Task 3',
      start: '2023-8-11',
      end: '2023-8-20',
      progress: 50,
      dependencies: 'Task 2'
    },
    {
      id: 'Task 4',
      name: 'Task 1 - Task 4',
      start: '2023-8-21',
      end: '2023-8-31',
      progress: 0,
      dependencies: 'Task 3'
    }

  ]
  var gantt = new Gantt("#gantt", tasks, {
    language: 'zh'
  });
});