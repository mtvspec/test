(function () {
  'use strict';
  
  angular.module('app')
  .controller('PersonAddCtrl', function (PersonsModel) {
    
    var vm = this;
    
    var personAddForm = {};
    vm.personAddForm = personAddForm;
    
    var personToAdd = {};
    vm.personToAdd = personToAdd;
    
    vm.hasError = hasError;
    function hasError(fieldName) {
      var field = personToAdd[fieldName];
      if (field) {
        return field.$invalid && (personAddForm.$submitted || !field.$pristine);
      }
    };
    
    function submit(person) {
      vm.personAddForm.$setSubmitted();
      if (vm.personAddForm.$valid) {
        console.log(vm.personToAdd);
        PersonsModel.createPerson(vm.personToAdd).then(function (response) {
          vm.closeDialog();
        });
      }
    };
    vm.closeDialog = closeDialog;
    function closeDialog() {
      
    };
  })
})();