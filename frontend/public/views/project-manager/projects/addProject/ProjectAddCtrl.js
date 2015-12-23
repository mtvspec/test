(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectAddCtrl', function ($http, $mdDialog, UserModel, ProjectsModel) {

    var vm = this,
    _url = '/api/projects/',
    _companiesUrl = '/api/companies/',
    _personsUrl = '/api/persons',
    projectAddForm = {},
    project = {},
    companies = [],
    persons = [],
    session = UserModel.getSession();

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

    vm.loadProjectManagers = loadProjectManagers;
    function loadProjectManagers() {
      $http({
        method: 'GET',
        url: _personsUrl,
        headers: {
          'session-id': session
        }
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
          vm.closeDialog();
        }, function (response) {
          console.log(response.status.statusText);
        });
			}
		};

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });

})();
