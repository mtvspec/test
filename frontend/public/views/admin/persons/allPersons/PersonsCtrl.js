(function () {
	'use strict';

	angular.module('app')
	.controller('PersonsCtrl', function (Model, $mdDialog) {

	var vm = this,
  _persons = [],
  _personsPromise = {},
  genders = [],
  PersonsModel = new Model(),
  _url = '/api/persons';

	vm.persons = _persons,
  vm.genders = genders;

  PersonsModel.getAllObjects({
    url: _url,
    data: {
      objects: _persons,
      objectsPromise: _personsPromise
    }
  }, function (data) {
    console.log(data);
  });

  function showPersonDetails(person) {
    console.debug(person);
  };
  vm.showPersonDetails = showPersonDetails;

  vm.addPerson = addPerson;
	function addPerson(ev) {
		$mdDialog.show({
			templateUrl: 'views/admin/persons/addPerson/addPersonTmpl.html',
			controller: 'PersonAddCtrl',
      controllerAs: 'vm',
      targetEvent: ev,
      clickOutsideToClose: false
    })
    .then(function () {

    }, function () {
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
