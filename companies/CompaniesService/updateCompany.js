'use strict';

var pg = require('pg');

function updateCompany(company, cb) {
  pg.connect(function (err, client, done) {
    if (err) {
      console.error('updateCompany: connect:\n', err);
      return cb(500);
    } else {
      client.query({
        text: 'UPDATE kpx.e_companies SET bin = $2, company_name = $3 WHERE id = $1',
        values: [
          company.id,
          company.bin,
          company.companyName
        ]
      }, function (err, result) {
        var rowCount;
        if (err) {
          console.error('updateCompany: query:\n', err);
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

module.exports = updateCompany;
