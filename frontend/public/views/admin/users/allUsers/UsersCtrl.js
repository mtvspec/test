(function () {
  'use strict';

  angular.module('app')
  .controller('UsersCtrl', function (UsersModel) {
    var vm = this;
    UsersModel.retrieveUsers().then(function (users) {
      vm.users = users;
    });
  });
})();
