'use strict';

var DBService = require('./DBService.js'), PGService = new DBService();

// new task
var task = {
  taskName: 'Task 2',
  taskDesc: 'Description 2'
};

// query and data
var INSERT_TASK = {
  text: 'INSERT INTO e_tasks (task_name, task_description) VALUES ({taskName}, {taskDesc}) RETURNING id',
  values: task
};

PGService.performQuery(INSERT_TASK, PGService.insertRecord, function (status, record) {
  console.log(status, record);
});