(function(){
	'use strict';

	angular.module('app')
	.controller('PersonAddCtrl', function ($mdDialog, $http) {

		var vm = this,
    _url = '/api/persons/',
    personAddForm = {},
    person = {};

    vm.personAddForm = personAddForm,
    vm.person = person;

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = personAddForm[fieldName];
			if(field){
				return field.$invalid && (personAddForm.$submitted || !field.$pristine);
			}
		};

    console.log(person);
    vm.submit = submit;
		function submit(data){
			vm.personAddForm.$setSubmitted();
			if(vm.personAddForm.$valid){
				$http({
          method: 'POST',
          url: _url,
          data: data
        }, function (response) {
          if (response.status === 201) {
            data.id = response.data.id;
          }
          vm.closeDialog();
        }, function (response) {
          vm.closeDialog();
        });
			}
		};

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

	});
})();
