(function () {
  'use strict';

  angular.module('app')
  .controller('PersonsDeleteCtrl', function ($mdDialog, Model, person) {
    var vm = this,
    PersonsModel = new Model();
    vm.person = person;

    PersonsModel;

  });
})();
