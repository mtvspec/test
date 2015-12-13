'use strict';

var validateCompanyID = require('./validateCompanyID.js'), validateCompanyData = require('./validateCompanyData.js');
var validateCompany = require('./validateCompany.js');

var CompaniesController = {
  validateCompanyID: function (id) {
    return validateCompanyID(id);
  },
  validateCompanyData: function (company) {
    return validateCompanyData(company);
  },
  validateCompany: function (company) {
    return validateCompany(company);
  }
};

module.exports = CompaniesController;
