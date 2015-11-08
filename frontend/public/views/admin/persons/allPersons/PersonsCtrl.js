(function () {
	'use strict';

	angular.module('app')
	.controller('PersonsCtrl', function (PersonsModel, $mdDialog) {

	var vm = this;

	var persons = [];
	vm.persons = persons;

  var genders = [];
  vm.genders = genders;

	PersonsModel.readAllPersons().then(function (persons) {
		vm.persons = persons;
    console.debug(vm.persons);
	}, function (error) {
		console.log(error);
	});


  var showPersonDetails = function(ev, person) {
    console.debug(person);
    $mdDialog.show({
      controller: 'PersonInfoCtrl',
      templateUrl: 'views/persons/personInfo/personInfo.html',
      controllerAs: 'vm',
      targetEvent: ev,
      clickOutsideToClose: false,
      locals: {
        person: person
      }
    })
    .then(function(answer) {
    }, function() {
    });
  };

  vm.showPersonDetails = showPersonDetails;

	var addPerson = function (ev) {
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