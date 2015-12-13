'use strict';

function validateCompany(company) {
  if (company) {
    company.id = Number(company.id);
    company.bin = String(company.bin);
    if (typeof company.id === 'number' && company.id > 0) {
      if (typeof company.bin === 'string' && /^\d{2}(0[1-9]|1[0-2])(0[1-9]|[1-2]\d|3[01])[0-6]\d{5}$/.test(company.bin)) {
        if (typeof company.companyName === 'string' && company.companyName.length > 0) {
          return true;
        }
      }
    }
  } else return false;
};

module.exports = validateCompany;
