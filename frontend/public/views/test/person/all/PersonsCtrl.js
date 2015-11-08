(function () {
  'use strict';
  
  angular.module('app')
  .controller('PersonsCtrl', function ($http) {
    
    var vm = this;
    
    var persons = [];
    vm.persons = persons;
    
    vm.submit = submit;
    
    vm.persons = getPersons();
    
    function getPersons() {
      console.log(data);
      $http({
        method: 'POST',
        url: '/api/persons/',
        data: data
      }).then(function (response) {
        if (response.data) {
          console.log(response.data);
          return response.data;
        }
      }, function (response) {
        console.log(response.statusCode.statusText);
      });
    };
    
  })
})();