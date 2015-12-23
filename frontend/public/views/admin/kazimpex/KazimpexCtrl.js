(function () {
  'use strict';

  angular.module('app')
  .controller('KazimpexCtrl', function ($http) {
    var vm = this;

    $http({
      method: 'GET',
      url: '/api/companies/871215301100'
    }).then(function (response) {
      console.info(response.data);
      vm.kazimpex = response.data;
    }, function (response) {
      // body...
    });

  });
})();
