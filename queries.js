var SELECT_TESTS = {
  text: 'SELECT id, test_name FROM e_tests ORDER BY id ASC'
};

var SELECT_TEST = {
  text: 'SELECT id, test_name FROM e_tests WHERE id = :id',
  values: [test.id]
};

var INSERT_TEST = {
  text: 'INSERT INTO e_tests (test_name) VALUES ($1) RETURNING id',
  values: [
    newTest.testName
  ]
};

var UPDATE_TEST = {
  text: 'UPDATE e_tests SET test_name = $2 WHERE id = $1',
  values: [
    updatedTest.id,
    updatedTest.testName
  ]
};

var DELETE_TEST = {
  text: 'DELETE FROM e_tests WHERE id = $1',
  values: [
    deletedTest.id
  ]
};