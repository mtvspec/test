(function () {
	'use strict';

	angular.module('app')
	.controller('PersonsCtrl', function ($http, $mdDialog) {

	var vm = this,
  persons = [],
  genders = [],
  _url = '/api/persons';

  vm.genders = genders;

  $http({
    method: 'GET',
    url: _url
  }).then(function (response) {
    vm.persons = response.data;
  }, function (response) {
    console.error(response.status.statusText);
  });

  vm.showPersonDetails = showPersonDetails;
  function showPersonDetails(person) {
    console.debug(person);
  };

  vm.addPerson = addPerson;
	function addPerson(ev) {
		$mdDialog.show({
			templateUrl: 'views/admin/persons/addPerson/addPersonTmpl.html',
			controller: 'PersonAddCtrl',
      controllerAs: 'vm',
      targetEvent: ev,
      clickOutsideToClose: false
    })
    .then(function (response) {
      console.log(response);
    }, function (response) {
      // body...
    });
	};

  vm.deletePerson = deletePerson;
  function deletePerson(ev, person) {
    $mdDialog.show({
      templateUrl: 'views/admin/persons/deletePerson/deletePersonTmpl.html',
      controller: 'PersonDeleteCtrl',
      controllerAs: 'vm',
      targetEvent: ev,
      clickOutsideToClose: true
    })
    .then(function () {
      // body...
    }, function () {
      // body...
    });
  };

	})
})();
