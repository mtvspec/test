(function () {
  'use strict';

  angular.module('app')
  .controller('LoginCtrl', function ($http, $state, UserModel) {
    var vm = this,
    user = {},
    User = {},
    url = '/api/users/login';
    vm.user = user,
    vm.login = login;

    function login(user) {
      UserModel.authentificateUser(user).then(function (data) {
        User = data;
        if (User.defaultRoleID === 1) {
          $state.go('admin.layout.main');
        }
        if (User.roles.length > 0) {
          $state.go('roles');
        }
      });
    };

  });
})();
