(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectAddCtrl', function ($http, $mdDialog, UserModel, PersonsModel, ProjectsModel) {

    var vm = this,
    _url = '/api/projects/',
    _companiesUrl = '/api/companies/',
    _personsUrl = '/api/persons',
    projectAddForm = {},
    project = {},
    companies = [],
    session = UserModel.getSession();
    vm.persons = PersonsModel.getPersons();

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

    vm.projectAddForm = projectAddForm,
    vm.project = project,
    vm.companies = companies,

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = projectAddForm[fieldName];
			if(field){
				return field.$invalid && (projectAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
		function submit(data){
			vm.projectAddForm.$setSubmitted();
			if(vm.projectAddForm.$valid){
				ProjectsModel.createProject(data).then(function (status) {
          console.log(status);
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
