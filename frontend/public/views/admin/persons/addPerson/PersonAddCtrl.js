(function(){
	'use strict';

	angular.module('app')
	.controller('PersonAddCtrl', function ($mdDialog, Model) {

		var vm = this,
    _url = '/api/persons/',
    personAddForm = {},
    person = {},
    PersonsModel = new Model();

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
		function submit(){
			vm.personAddForm.$setSubmitted();
			if(vm.personAddForm.$valid){
				PersonsModel.createObject({
          url: _url,
          data: vm.person
        })
        .then(function(response){
          closeDialog();
				}, function (response) {
				  console.error(response.status.statusText);
          // TODO Show message
          closeDialog();
				});
			}
		};

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

	});
})();
