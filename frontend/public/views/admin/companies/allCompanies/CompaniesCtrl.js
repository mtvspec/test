(function () {
  'use strict';

  angular.module('app')
  .controller('CompaniesCtrl', function ($http, $mdDialog) {
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

    vm.addCompany = addCompany;
  	function addCompany(ev) {
  		$mdDialog.show({
  			templateUrl: 'views/admin/companies/addCompany/addCompanyTmpl.html',
  			controller: 'CompanyAddCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false
      })
      .then(function (response) {
        console.log(response);
        // on success
      }, function (response) {
        console.log(response);
        // on failure
      });
  	};

  });
})();
