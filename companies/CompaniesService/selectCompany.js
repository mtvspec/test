'use strict';

var pg = require('pg');

function selectCompany(company, cb) {
  pg.connect(function (err, client, done) {
    if (!err) {
      client.query({
        text: 'SELECT id, bin, company_name FROM kpx.e_companies WHERE id = $1',
        values: [company.id]
      }, function (err, result) {
        var rowCount;
        if (!err) {
          done();
          rowCount = result.rowCount;
          if (rowCount === 1) {
            return cb(200, result.rows[0]);
          } else {
            return cb(204, null);
          }
        } else {
          console.error('selectCompany: select');
          return cb(500, null);
        }
      });
    } else {
      console.error('selectCompany: connect', err);
      return cb(500, null);
    }
  });
};
