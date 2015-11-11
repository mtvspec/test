(function () {
  'use strict';

  angular.module('app')
  .controller('LoginCtrl', function ($http) {
    var vm = this,
    user = {},
    url = '/api/users/login';
    vm.user = user,
    vm.login = login;

    function login(user) {
      console.log(user);
      $http({
        method: 'POST',
        url: url,
        data: user
      }).then(function (response) {
        console.log(response.status.statusText.data);
      }, function (response) {
        console.error(response.status.statusText);
      });
    };

  });
})();
