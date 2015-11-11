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

  _personsPromise = PersonsModel.getAllObjects({
    url: _url,
    data: {
      objects: _persons
    }
  }, function () {
  });

  function showPersonDetails(person) {
    console.debug(person);
  };
  vm.showPersonDetails = showPersonDetails;

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
	}
	vm.addPerson = addPerson;

	})
})();
