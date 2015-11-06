'use strict';

function Controller() {
};

Controller.prototype.validateID = function validateID(id, cb) {
  var res;
  if (id) {
    typeof id === 'number' && id > 0 ? res = true : res = false;
    return res;
  }
  return false;
};

module.exports = Controller;