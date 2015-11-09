(function () {
  'use strict';
  
  angular.module('app')
  .controller('PersonCtrl', function ($http) {
    
    
    var vm = this;
    var persons;
    
    vm.persons = getPersons();
    
    function getPersons() {
      $http({
        method: 'GET',
        url: '/api/persons/',
      }).then(function (response) {
        if (response.data) {
          persons = response.data;
          console.log(persons);
          return persons;
        }
      }, function (response) {
        console.log(response.status.statusText);
      });
    };
    
    console.log(vm.persons);
    
    var person = {};
    vm.person = person;
    
    vm.submit = submit;
    function submit(data) {
      console.log(data);
      $http({
        method: 'POST',
        url: '/api/persons/',
        data: data
      }).then(function (response) {
        console.log(response.data);
        if (response.data.iin == data.iin) {
          console.log('Updated');
        }
      }, function (response) {
        console.log(response);
      });
    };
    
  })
})();