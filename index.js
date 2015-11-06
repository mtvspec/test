'use strict';

var PGService = new DBService();

function PGService() {
  
};

PGService.selectRecord(SELECT_TEST, function (status, record) {
  var test;
  if (status === 200) {
    DBUtils.toCamelCase(record, function (record) {
      return record;
    });
  }
  console.log(status, record);
});

/**
* @function
* Запрос всех физических лиц
* @return
* @type success
* @name
* {number} status statusCode 200
* {array} persons personsCollection
* @name persons not found (empty resource)
* {number} status statusCode 2004
* @type failure
* @name server error
* {number} status statusCode 500
*/
PGService.selectRecords(SELECT_TESTS, function (status, records) { // TODO конвертировать результат в camelCase специальной функцией, и сделать метод прототипом
  if (status === 200) {
    var tests = records.map(function (record) {
      return {
        id: record.id,
        testName: record.test_name
      };
    });
  }
  console.log(status, tests);
});
/**
* @function
* Вставка нового физического лица
* @params
* {string} iin ИИН физического лица // TODO Необходимо проверять ИИН по маске
* {string} lastName Фамилия физического лица
* {string} firstName Имя физического лица
* {string} middleName Отчество физического лица
* {date} dob Дата рождения физического лица // TODO Может быть извлекать дату рождения из ИИН?
* {number} genderID Идентификатор пола физического лица // TODO Может быть извлекать пол из ИИН?
* @return
* @type success
* @name person created
* {number} status statusCode 201
* @type failure
* @name required person's data not found
* 
*/
PGService.insertRecord(INSERT_TEST, function (status, record) { // TODO сделать метод прототипом
  return cb{status, record};
});

PGService.updateRecord(UPDATE_TEST, function (status) {
  return cb(status);
});

PGService.deleteRecord(DELETE_TEST, function (status) {
  return cb(status);
});