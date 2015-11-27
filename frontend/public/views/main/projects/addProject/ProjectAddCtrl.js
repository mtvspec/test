(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectAddCtrl', function ($http, $mdDialog) {

    var vm = this,
    _url = '/api/projects/',
    _companiesUrl = '/api/companies/',
    _personsUrl = '/api/persons',
    projectAddForm = {},
    project = {},
    companies = [],
    persons = [];

    vm.loadCustomers = loadCustomers;
    function loadCustomers() {
      $http({
        method: 'GET',
        url: _companiesUrl
      }).then(function (response) {
        if (response.status === 200) {
          vm.companies = response.data;
        }
      });
    };

    vm.loadPersons = loadPersons;
    function loadPersons() {
      $http({
        method: 'GET',
        url: _personsUrl
      }).then(function (response) {
        if (response.status === 200) {
          vm.persons = response.data;
        }
      });
    };

    vm.projectAddForm = projectAddForm,
    vm.project = project,
    vm.companies = companies,
    vm.persons = persons;

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = projectAddForm[fieldName];
			if(field){
				return field.$invalid && (projectAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
		function submit(data){
      console.log(data);
			vm.projectAddForm.$setSubmitted();
			if(vm.projectAddForm.$valid){
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
          console.log(response.status.statusText);
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
