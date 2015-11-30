(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectCtrl', function ($stateParams) {
    var vm = this,
    projectID = 0;
    vm.projectID = $stateParams.id;
  });

})();
