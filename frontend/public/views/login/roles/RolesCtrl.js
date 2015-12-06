(function () {
  'use strict';

  angular.module('app')
  .controller('RolesCtrl', function ($http, $state, UserModel) {
    var vm = this,
    User = UserModel.getUser();
    vm.User = User;

    vm.selectRole = selectRole;
    function selectRole(id) {
      switch (id) {
        case 1:
          $state.go('admin.layout.main');
          break;
        case 2:
          $state.go('main.layout.main');
          break;
        default:
          return;
          break;
      }
    };
  })
})();
