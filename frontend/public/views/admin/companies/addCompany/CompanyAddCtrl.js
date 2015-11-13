(function () {
  'use strict';

  angular.module('app')
  .controller('ContactsAddController', function ($http) {
    var vm = this,
    url = '/api/companies',
    company = {};
    vm.company = company;

    vm.submit = submit;
    function submit(data) {
      console.log(data);
      $http({
        method: 'POST',
        url: url,
        data: data
      }).then(function (response) {
        if (response.status === 201) {
          data.id = response.data.id;
        }
      }, function (response) {
        console.error(response.status.statusText);
      });
    };

  });

})();
