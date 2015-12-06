(function () {
  'use strict';

  angular.module('app')
  .controller('SignupCtrl', function ($http) {
    var vm = this,
    user = {},
    url = '/api/users/signup';
    vm.user = user,
    vm.signup = signup;

    function signup(user) {
      $http({
        method: 'POST',
        url: url,
        data: user
      }).then(function (response) {
        console.log(response.status.statusText, response.data);
      }, function (response) {
        console.error(response.status.statusText);
      });
    };

  });
})();
