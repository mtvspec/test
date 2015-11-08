(function () {
  'use strict';
  
  angular.module('app')
  .controller('PersonEditCtrl', function ($http) {
    
    var vm = this;
    
    var person = {};
    vm.person = person;
    
    vm.submit = submit;
    
    function submit(data) {
      console.log(data);
      $http({
        method: 'PUT',
        url: '/api/persons',
        data: data
      }).then(function (response) {
        console.log(response.data);
      }, function (response) {
        console.log(response);
      });
    };
    
  })
})();