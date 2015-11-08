(function(){
	'use strict';

	angular.module('app')
	.controller('PersonAddCtrl', function ($mdDialog, PersonsModel) {

		var vm = this;

		var personAddForm = {};

		vm.personAddForm = personAddForm;

		var personToAdd = {};

		vm.personToAdd = personToAdd;

		vm.hasError = hasError;
		vm.submit = submit;

		function hasError(fieldName){
			var field = personAddForm[fieldName];
			if(field){
				return field.$invalid && (personAddForm.$submitted || !field.$pristine);
			}
		};

		function submit(){
			vm.personAddForm.$setSubmitted();
			if(vm.personAddForm.$valid){
				console.log(vm.personToAdd);
				PersonsModel.createPerson(vm.personToAdd).then(function(response){
					closeDialog();
				});
			}
		};

    function closeDialog() {
      $mdDialog.cancel();
    };

    vm.closeDialog = closeDialog;

	});
})();
