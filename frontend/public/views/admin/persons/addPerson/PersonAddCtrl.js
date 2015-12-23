(function(){
	'use strict';

	angular.module('app')
	.controller('PersonAddCtrl', function ($mdDialog, $http, PersonsModel) {

		var vm = this,
    _url = '/api/persons/',
    personAddForm = {},
    person = {};
    vm.genders = PersonsModel.getGenders();

    vm.personAddForm = personAddForm,
    vm.person = person;

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = personAddForm[fieldName];
			if(field){
				return field.$invalid && (personAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
		function submit(data){
			vm.personAddForm.$setSubmitted();
			if(vm.personAddForm.$valid){
				PersonsModel.createPerson(data).then(function (status) {
				  if (status === 201) {
				    closeDialog();
				  }
				})
			}
		};

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

	});
})();
