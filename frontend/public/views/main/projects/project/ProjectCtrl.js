(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectCtrl', function ($http, $mdDialog, $stateParams, ProjectModel) {
    var vm = this,
    _url = '/api/projects/',
    _projectResultTypesUrl = '/api/dict/project-result-types',
    _projectResultParentsUrl = '/api/projects/',
    _projectResultStatusesUrl = '/api/dict/project-result-statuses',
    _personsUrl = '/api/persons',
    projectResultAddForm = {},
    results = [],
    types = [],
    parents = [],
    statuses = [],
    projectID = 0;
    vm.projectID = $stateParams.id,
    vm.results = results,
    vm.types = loadProjectResultTypes(),
    vm.persons = loadPersons();

    vm.getTypeNameByID = getTypeNameByID;
    function getTypeNameByID(types, typeID) {
      var typeName;
      for (var i = 0; i < types.length; i++) {
        if (types[i].id === typeID) {
          typeName = types[i].typeName;
        }
      }
      return typeName;
    };

    vm.getPersonLastnameByID = getPersonLastnameByID;
    function getPersonLastnameByID(persons, authorID) {
      var lastName;
      for (var i = 0; i < persons.length; i++) {
        if (persons[i].id === authorID) {
          lastName = persons[i].lastName;
        }
      }
      return lastName;
    };

    vm.getPersonFirstnameByID = getPersonFirstnameByID;
    function getPersonFirstnameByID(persons, authorID) {
      var firstName;
      for (var i = 0; i < persons.length; i++) {
        if (persons[i].id === authorID) {
          firstName = persons[i].firstName;
        }
      }
      return firstName;
    };

    vm.getPersonMiddlenameByID = getPersonMiddlenameByID;
    function getPersonMiddlenameByID(persons, authorID) {
      var middleName;
      for (var i = 0; i < persons.length; i++) {
        if (persons[i].id === authorID) {
          middleName = persons[i].middleName;
        }
      }
      return middleName;
    };

    vm.loadProjectResultTypes = loadProjectResultTypes;
    function loadProjectResultTypes() {
      $http({
        method: 'GET',
        url: _projectResultTypesUrl
      }).then(function (response) {
        if (response.status === 200) {
          vm.types = response.data;
        }
      });
    };

    vm.loadProjectResultParents = loadProjectResultParents;
    function loadProjectResultParents() {
      $http({
        method: 'GET',
        url: _projectResultParentsUrl + vm.projectID + '/results'
      }).then(function (response) {
        if (response.status === 200) {
          vm.parents = response.data;
        }
      });
    };

    vm.loadProjectResultStatuses = loadProjectResultStatuses;
    function loadProjectResultStatuses() {
      $http({
        method: 'GET',
        url: _projectResultStatusesUrl
      }).then(function (response) {
        if (response.status === 200) {
          vm.statuses = response.data;
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

    $http({
      method: 'GET',
      url: _url + vm.projectID + '/results'
    }).then(function (response) {
      return vm.results = response.data;
    }, function (response) {
      console.error(response.status.statusText);
    });

    vm.addProjectResult = addProjectResult;
    function addProjectResult(id, ev) {
      $mdDialog.show({
  			templateUrl: 'views/main/projects/project/results/addProjectResult/addProjectResultTmpl.html',
  			controller: 'ProjectCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false,
        locals: id
      })
      .then(function () {
        // on success
      }, function () {
        // on failure
      });
    };

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = projectResultAddForm[fieldName];
			if(field){
				return field.$invalid && (projectResultAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
		function submit(data){
      console.log(data);
			vm.projectResultAddForm.$setSubmitted();
			if(vm.projectResultAddForm.$valid){
				$http({
          method: 'POST',
          url: _url + vm.projectID + '/results',
          data: data
        }).then(function (response) {
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
    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });

})();
