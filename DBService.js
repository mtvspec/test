'use strict';

var pg = require('pg');

var Utils = require('utils');

var DBUtils = new Utils();

function DBService() {
  
};

DBService.prototype.selectRecords = function selectRecords(query, cb) {
  if (!query) {
    return cb(400, null);
  }
  pg.connect(function (err, client, done) {
    if (err) {
      console.error('selectRecords: connect:\n', err);
      return cb(500, null);
    }
    client.query({
      text: query.text
    }, function (err, result) {
      var rowCount, records = [];
      if (err) {
        console.error('selectRecords: query:\n', err);
        return cb(500, null);
      }
      done();
      rowCount = result.rowCount;
      if (rowCount === 0) {
        return cb(204, null);
      }
      if (rowCount > 0) {
        for (var i = 0, len = result.rows.length; i < len; i++) {
          DBUtils.toCamelCase(result.rows[i], function (record) {
            records.push(record);
          });
        }
        return cb(200, records);
      }
      return cb(500, null);
    });
  });
};

DBService.prototype.selectRecord = function selectRecord(query, cb) {
  if (!query) {
    return cb(400, null);
  }
  pg.connect(function (err, client, done) {
    if (err) {
      console.error(err);
      return cb(500, null);
    }
    client.query({
      text: query.text,
      values: query.values
    }, function (err, result) {
      var rowCount, record;
      if (err) {
        console.error(err);
        return cb(500, null);
      }
      done();
      rowCount = result.rowCount;
      if (rowCount === 0) {
        return cb(204, null);
      }
      if (rowCount === 1) {
        record = DBUtils.toCamelCase(result.rows[0], function (record) {
          return record;
        });
        return cb(200, record);
      }
      return cb(500, null);
    });
  });
};

DBService.prototype.insertRecord = function insertRecord(query, cb) {
  console.log(query);
  if (!query) {
    return cb(400, null);
  }
  pg.connect(function (err, client, done) {
    if (err) {
      console.error('insertRecord: connect:\n', err);
      return cb(500, null);
    }
    client.query({
      text: query.text,
      values: query.values
    }, function (err, result) {
      var rowCount;
      if (err) {
        console.error('insertRecord: query:\n', err);
        return cb(500, null);
      }
      done();
      rowCount = result.rowCount;
      if (rowCount === 0) {
        return cb(400, null);
      }
      if (rowCount === 1) {
        return cb(201, result.rows[0]);
      }
      return cb(500, null);
    });
  });
};

DBService.prototype.updateRecord = function updateRecord(query, cb) {
  if (!query) {
    return cb(400);
  }
  pg.connect(function (err, client, done) {
    if (err) {
      console.error('updateRecord: connect:\n', err);
      return cb(500);
    }
    client.query({
      text: query.text,
      values: query.values
    }, function (err, result) {
      var rowCount;
      if (err) {
        console.error('updateRecord: query:\n', err);
        return cb(500);
      }
      done();
      rowCount = result.rowCount;
      if (rowCount === 0) {
        return cb(204);
      }
      if (rowCount === 1) {
        return cb(200);
      }
      return cb(500);
    });
  });
};

DBService.prototype.deleteRecord = function deleteRecord(query, cb) {
  if (!query) {
    return cb(400);
  }
  pg.connect(function (err, client, done) {
    if (err) {
      console.error('deleteRecord: connect:\n', err);
      return cb(500);
    }
    client.query({
      text: query.text,
      values: query.values
    }, function (err, result) {
      var rowCount;
      if (err) {
        console.error('deleteRecord: query:\n', err);
        return cb(500);
      }
      done();
      rowCount = result.rowCount;
      if (rowCount === 0) {
        return cb(204);
      }
      if (rowCount === 1) {
        return cb(200);
      }
      return cb(500);
    });
  });
};

DBService.prototype.performQuery = function performQuery(query, queryFn, cb) {
  var placeholders = {};
  var replacements = [];
  var counter = 1;
  var key;
  for (key in query.values) {
    if (query.values.hasOwnProperty(key)) {
      placeholders[key] = '$' + counter;
      replacements.push(query.values[key]);
      counter++;
    }
  }
  
  query = {
    text: format(query.text, placeholders),
    values: replacements
  };

  queryFn(query,
    function (status, record) {
      if (typeof cb === 'function') {
        cb(status, record);
      }
    }
  );
};

function format(queryText, queryValues) {
  return queryText.replace(/{([^{}]*)}/g, function (match, partName) {
    var replacement = queryValues[partName];
    if (!replacement) {
      throw new Error('Not found');
    }
    return (typeof replacement === 'string') ||
    typeof replacement === 'number' ? replacement : match;
  });
};

module.exports = DBService;