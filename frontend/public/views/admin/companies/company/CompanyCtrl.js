(function () {
  'use strict';

  angular.module('app')
  .controller('CompanyCtrl', function (locals, $mdDialog, PersonsModel) {
    var vm = this;
    vm.company = locals.company;

    vm.persons = PersonsModel.getPersons();

    vm.addPerson = addPerson;
    function addPerson(id, ev) {
      $mdDialog.show({
  			templateUrl: 'views/admin/companies/company/addPerson/addPersonTmpl.html',
  			controller: 'Person$AddCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false,
        locals: {
          id: id
        }
      })
      .then(function (response) {
        console.log(response);
        // on success
      }, function (response) {
        console.log(response);
        // on failure
      });
    };

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });

})();
