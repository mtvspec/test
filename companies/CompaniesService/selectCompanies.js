'use strict';

var pg = require('pg');

function selectCompanies(cb) {
  pg.connect(function (err, client, done) {
    if (!err) {
      client.query({
        text: 'SELECT id, bin, company_name FROM kpx.e_companies ORDER BY id ASC'
      }, function (err, result) {
        var rowCount, companies;
        if (!err) {
          done();
          rowCount = result.rowCount;
          if (rowCount > 0) {
            companies = [];
            for(var i = 0, len = result.rows.length; i < len; i++){
              companies.push({
                id: result.rows[i].id,
                bin: result.rows[i].bin,
                companyName: result.rows[i].company_name
              });
            }
            return cb(200, companies);
          } else {
            return cb(204, null);
          }
        } else {
          console.error('selectCompanies: select:', err);
          return cb(500, null);
        }
      });
    } else {
      console.error('selectCompanies: connect:', err);
      return cb(500, null);
    }
  });
}

module.exports = selectCompanies;
