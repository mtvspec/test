(function () {
  'use strict';

  angular.module('app')
  .controller('LoginCtrl', function ($http, $state, UserModel) {
    var vm = this,
    url = '/api/users/login';
    vm.login = login;
    function login(user) {
      UserModel.authentificateUser(user).then(function (User) {
        if (User.defaultRoleID && User.defaultRoleID === 1) {
          $state.go('roles');
        }
      }, function (error) {
        console.error(error);
      });
    };
  });
})();
