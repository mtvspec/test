(function () {
  'use strict';

  angular.module('app')
  .controller('RolesCtrl', function ($http, $state, UserModel, PersonsModel) {
    var vm = this;
    vm.User = UserModel.getUser();

    vm.selectRole = selectRole;
    function selectRole(roleID) {
      UserModel.openSession({userID: vm.User.id, roleID: roleID}).then(
        function (token) {
          console.log(token);
        }, function (error) {
          console.log(error);
        }
      );
      switch (roleID) {
        case 1:
          $state.go('admin.layout.main');
          break;
        case 2:
          $state.go('main.layout.main');
          break;
        case 3:
          $state.go('manager.layout.main');
          break;
        default:
          return;
          break;
      }
    };

  });

})();
