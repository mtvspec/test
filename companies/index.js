'use strict';

var companies = require('express').Router();
var CompaniesController = require('./CompaniesController');
var CompaniesService = require('./CompaniesService');

companies
/**
 * @description
 * Get all companies
 * @return
 * @type success
 * {number} status status 200
 * {array} companies companies collection
 * @name no companies
 * {number} status status 204
 * @type failure
 * @name server error
 * {number} status status 500
 */
.get('/', function (request, response) {
	var res;
	CompaniesService.retrieveCompanies(function (status, companies) {
		res = response.status(status);
		if (status === 200) {
			res.json(companies);
		}
		return res.end();
	});
})
/**
 * @description
 * Get company by id
 * @param
 * {number} id company id
 * @return
 * @type success
 * {number} status status code 200
 * {array} company company
 * @name no company
 * {number} status status code 204
 * @type failure
 * @name company id not found in request params
 * {number} status status code 400
 * @name server error
 * {number} status status code 500
 */
.get('/:id', function (request, response) {
  var res;
  var company = {
    /** @type {number} */
    id: request.params.id
  };
  if (CompaniesController.validateCompanyId(company.id)) {
    CompaniesService.retrieveCompany(company.id, function (status, company) {
      res = response.status(status);
      if (status === 200) {
        res.json(company);
      }
      return res.end();
    });
  } else {
    return response.status(400).end();
  }
})
/**
 * @description
 * Create a company
 * @param
 * {string} bin person bin
 * {string} companyName company name
 * @return
 * @type success
 * @name company created
 * {number} status status code 201
 * {number} id created company id
 * @type failure
 * @name bin and(or) company name not found in request body
 * {number} status status code 400
 * @name server error
 * {number} status status code 500
 */
.post('/', function (request, response) {
  var res;
  var company = {
    /** @type {number} */
    bin: request.body.bin,
    /** @type {string} */
    companyName: request.body.companyName
  };
  if (CompaniesController.validateCompanyData(company)) {
    CompaniesService.createCompany(company, function (status, id) {
      res = response.status(status);
      if (status === 201) {
        res.json({id: id});
      }
      return res.end();
    });
  } else {
    return response.status(400).end();
  }
})
/**
 * @description
 * Update company by id
 * @param
 * {number} id company id
 * {string} bin company bin
 * {string} companyName company name
 * @return
 * @type success
 * @name company updated
 * {number} status status code 200
 * @name no company
 * {number} status status code 204
 * @type failure
 * @name company id and(or) required data not found in request params and(or) body
 * {number} status status code 400
 * @name server error
 * {number} status status code 500
 */
.put('/:id', function (request, response) {
  var company = {
    /** @type {number} (required) */
    id: request.params.id,
    /** @type {string} (required) */
    bin: request.body.bin,
    /** @type {string} (required) */
    companyName: request.body.companyName
  };
  if (CompaniesController.validateCompany(company)) { // TODO создать validateCompany
    CompaniesService.saveCompany(company, function (status) { // TODO создать updateCompany
      return response.status(status).end();
    });
  } else {
    return response.status(400).end();
  }
})
/**
 * @description
 * Delete company by id
 * @param
 * {number} id company id
 * @return
 * @type success
 * @name company deleted
 * {number} status status code 200
 * @name no company
 * {number} status status code 204
 * @type failure
 * @name company id not found in request params
 * {number} status status code 400
 * @name server error
 * {number} status status code 500
 */
.delete('/:id', function (request, response) {
  var company = {
    /** @type {number} required */
    id: request.params.id
  };
  if (CompaniesController.validateCompanyId(company.id)) {
    CompaniesService.removeCompany(company.id, function (status) { // TODO создать deleteCompany
      return response.status(status).end();
    });
  } else {
    return response.status(400).end();
  }
});

module.exports = companies;
