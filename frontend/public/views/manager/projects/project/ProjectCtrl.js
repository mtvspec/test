(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectCtrl', function ($http, $mdDialog, $stateParams, ProjectModel, PersonsModel, ProjectsResultsModel, DictModel) {
    var vm = this,
    _projectResultTypesUrl = '/api/dict/project-result-types',
    _projectResultStatusesUrl = '/api/dict/project-result-statuses',
    projectResultAddForm = {};
    vm.projectID = $stateParams.id,
    vm.persons = PersonsModel.getPersons(),
    vm.types = DictModel.getResultTypes();

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

    ProjectsResultsModel.retrieveProjectResults(vm.projectID).then(function (results) {
      vm.results = results;
    });

    vm.addProjectResult = addProjectResult;
    function addProjectResult(id, ev) {
      $mdDialog.show({
  			templateUrl: 'views/manager/projects/project/results/addProjectResult/addProjectResultTmpl.html',
  			controller: 'ProjectResultAddCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false,
        locals: {
          id: id
        }
      })
      .then(function () {
        // on success
      }, function () {
        // on failure
      });
    };

  });

})();
