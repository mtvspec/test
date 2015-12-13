'use strict';

function validateCompanyID(id) {
  id = Number(id);
  if (typeof id === 'number' && id > 0) {
    return true;
  } else return false;
};

module.exports = validateCompanyID;
