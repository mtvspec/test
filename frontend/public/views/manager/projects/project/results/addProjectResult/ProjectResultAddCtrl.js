(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectResultAddCtrl', function ($http, $mdDialog, locals, ProjectResultsModel, PersonsModel) {

    var vm = this,
    _projectResultTypesUrl = '/api/dict/project-result-types',
    _projectResultParentsUrl = '/api/projects/',
    parents = [],
    projectID = locals.id;
    vm.persons = PersonsModel.getPersons();

    loadProjectResultTypes();
    loadProjectResultParents();

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = projectResultAddForm[fieldName];
			if(field){
				return field.$invalid && (projectResultAddForm.$submitted || !field.$pristine);
			}
		};

    function loadProjectResultTypes() {
      $http({
        method: 'GET',
        url: _projectResultTypesUrl
      }).then(function (response) {
          return vm.types = response.data;
      }, function (response) {
        console.error(response.status, response.statusText);
      });
    };
    
    vm.loadProjectResultParents = loadProjectResultParents();
    function loadProjectResultParents() {
      ProjectResultsModel.getProjectResults(vm.projectID).then(function (parents) {
        vm.parents = parents;
      });
    };

    vm.submit = submit;
		function submit(data){
			vm.projectResultAddForm.$setSubmitted();
			if(vm.projectResultAddForm.$valid){
				ProjectResultsModel.createProjectResult(projectID, data).then(function (result) {
          if (result === 201) {
            closeDialog();
          }
				});
			}
		};

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });
})();
