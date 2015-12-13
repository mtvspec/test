'use strict';

var pg = require('pg');

function deleteCompany(id, cb) {
  pg.connect(function (err, client, done) {
    if (err) {
      console.error('deleteCompany: connect:\n', err);
      return cb(500);
    } else {
      client.query({
        text: 'DELETE FROM kpx.e_companies WHERE id = $1',
        values: [id]
      }, function (err, result) {
        var rowCount;
        if (err) {
          console.error('deleteCompany: query:\n');
          return cb(500);
        } else {
          done();
          rowCount = result.rowCount;
          if (rowCount === 1) {
            return cb(200);
          } else {
            return cb(204);
          }
        }
      });
    }
  });
};

module.exports = deleteCompany;
