(function () {
  'use strict';
  
  angular.module('app')
  .controller('CompaniesCtrl', function ($http) {
    var vm = this;
    
    var _url = '/api/companies/';
    
    console.log(vm.companies);
    
    (function getAllCompanies() {
      $http({
        method: 'GET',
        url: _url
      }).then(function (response) {
        if (response.status === 200) {
          vm.companies = response.data;
        } else {
          return null;
        }
      }, function (response) {
        console.error(response.status.statusText);
      })
    })();
    
  });
})();