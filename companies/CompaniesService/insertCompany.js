'use strict';

var pg = require('pg');

function insertCompany(company, cb) {
  pg.connect(function (err, client, done) {
    if (!err) {
      client.query({
        text: 'INSERT INTO kpx.e_companies (bin, company_name) VALUES ($1, $2) RETURNING id',
        values: [
          company.bin,
          company.companyName
        ]
      }, function (err, result) {
        var rowCount;
        if (!err) {
          done();
          rowCount = result.rowCount;
          if (rowCount === 1) {
            return cb(201, result.rows[0].id);
          } else {
            return cb(400, null);
          }
        } else {
          console.error('insertCompany: insert:', err);
          return cb(500, null);
        }
      });
    } else {
      console.error('insertCompany: connect:', err);
      return cb(500, null);
    }
  });
}

module.exports = insertCompany;
