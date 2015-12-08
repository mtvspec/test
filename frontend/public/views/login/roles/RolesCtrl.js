(function () {
  'use strict';

  angular.module('app')
  .controller('RolesCtrl', function ($http, $state, UserModel, PersonsModel) {
    var vm = this;
    vm.User = UserModel.getUser();
    PersonsModel.readPerson({id: vm.User.person.id}).then(
      function (person) {
        vm.User.person = person;
    },
      function (error) {
        console.error(error);
    });
    UserModel.authoriseUser(vm.User.userID).then(
      function (roles) {
        vm.User.roles = roles;
    },
      function (error) {
        console.error(error);
    });

    console.log(vm.User);

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
