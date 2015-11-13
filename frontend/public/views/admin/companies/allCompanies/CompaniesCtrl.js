(function () {
  'use strict';

  angular.module('app')
  .controller('CompaniesCtrl', function ($http) {
    var vm = this,
    url = '/api/companies';

    $http({
      method: 'GET',
      url: url
    })
    .then(function (response) {
      vm.companies = response.data;
    }, function (response) {
      console.error(response.status.statusText);
    });
    
  });
})();
