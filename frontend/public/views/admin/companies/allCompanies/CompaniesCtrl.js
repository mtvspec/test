(function () {
  'use strict';
  
  angular.module('app')
  .controller('CompaniesCtrl', function () {
    var vm = this;
    vm.companies = [
      {
        companyName: 'Казимпэкс'
      }
    ]
  });
})();