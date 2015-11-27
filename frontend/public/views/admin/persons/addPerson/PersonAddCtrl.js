(function(){
	'use strict';

	angular.module('app')
	.controller('PersonAddCtrl', function ($mdDialog, $http) {

		var vm = this,
    _url = '/api/persons/',
    _gendersUrl = '/api/dict/genders',
    personAddForm = {},
    person = {},
    genders = [];

    vm.personAddForm = personAddForm,
    vm.person = person,
    vm.genders = genders;

    vm.loadGenders = loadGenders;
    function loadGenders() {
      $http({
        method: 'GET',
        url: _gendersUrl
      }).then(function (response) {
        if (response.status === 200) {
          vm.genders = response.data;
        }
      }, function (response) {
        console.error(response.status.statusText);
      });
    };

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
          closeDialog();
        }, function (response) {
          console.error(response.status.statusText);
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
