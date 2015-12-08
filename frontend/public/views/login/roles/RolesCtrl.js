(function () {
  'use strict';

  angular.module('app')
  .controller('RolesCtrl', function ($http, $state, UserModel) {
    var vm = this,
    _personsUrl = '/api/persons',
    persons = [];
    vm.User = UserModel.getUser(),
    vm.persons = persons;

    $http({
      method: 'GET',
      url: _personsUrl
    }).then(function (response) {
      if (response.status === 200) {
        vm.persons = response.data;
      }
    });

    vm.getPersonFirstnameByID = getPersonFirstnameByID;
    function getPersonFirstnameByID(persons, personID) {
      var firstName;
      for (var i = 0; i < persons.length; i++) {
        if (persons[i].id === personID) {
          firstName = persons[i].firstName;
        }
      }
      return firstName;
    };

    vm.getPersonMiddlenameByID = getPersonMiddlenameByID;
    function getPersonMiddlenameByID(persons, personID) {
      var middleName;
      for (var i = 0; i < persons.length; i++) {
        if (persons[i].id === personID) {
          middleName = persons[i].middleName;
        }
      }
      return middleName;
    };

    vm.selectRole = selectRole;
    function selectRole(id) {
      switch (id) {
        case 1:
          $state.go('admin.layout.main');
          break;
        case 2:
          $state.go('main.layout.main');
          break;
        default:
          return;
          break;
      }
    };
  })
})();
