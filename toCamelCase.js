var test = {
  id: 1,
  test_name: 'Test'
};

DBUtils.toCamelCase(test, function(test) {
  console.log(test);
});



