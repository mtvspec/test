'use strict';

var CompaniesModel = require('../CompaniesModel'), selectCompanies = require('./selectCompanies.js');
var selectCompany = require('./selectCompany.js'), insertCompany = require('./insertCompany.js');
var updateCompany = require('./updateCompany.js'), deleteCompany = require('./deleteCompany.js');

var CompaniesService = {
  retrieveCompanies: function retrieveCompanies(cb) {
    if (CompaniesModel.length === 0) {
      selectCompanies(function (status, companies) {
        if (status === 200) {
          var i, len;
          for (i = 0, len = companies.length; i < len; i++){
            CompaniesModel.push(companies[i]);
          }
          return cb(status, CompaniesModel);
        } else {
          return cb(status);
        }
      });

    } else {
      return cb(200, CompaniesModel);
    }
  },
  retrieveCompany: function retrieveCompany(id, cb) {
    var i, len, status, company;
    for (i = 0, len = CompaniesModel.length; i < len; i++) {
      if (CompaniesModel[i].id == id) {
        status = 200;
        company = CompaniesModel[i];
        break;
      } else {
        status = 204;
        company = null;
      }
    }
    return cb(status, company);
  },
  createCompany: function createCompany(company, cb) {
    insertCompany(company, function (status, id) {
      if (status === 201) {
        company.id = id;
        CompaniesModel.push(company);
        return cb(status, id);
      } else {
        return cb(status, null);
      }
    });
  },
  saveCompany: function saveCompany(company, cb) {
    updateCompany(company, function (status) {
      if (status === 200) {
        for (var i = 0, len = CompaniesModel.length; i < len; i++) {
          if (CompaniesModel[i].id == company.id) {
            CompaniesModel[i].bin = company.bin;
            CompaniesModel[i].companyName = company.companyName;
            break;
          }
        }
        return cb(status);
      } else {
        return cb(status);
      }
    });
  },
  removeCompany: function removeCompany(id, cb) {
    deleteCompany(id, function (status) {
      if (status === 200) {
        var i, len;
        for (var i = 0, len = CompaniesModel.length; i < len; i++) {
          if (CompaniesModel[i].id == id) {
            CompaniesModel.splice(i, 1);
            break;
          }
        }
        return cb(status);
      } else {
        return cb(status);
      }
    });
  }
}

if (CompaniesModel.length === 0) {
  CompaniesService.retrieveCompanies(function (companies) {
    return CompaniesModel;
  });
}

module.exports = CompaniesService;
