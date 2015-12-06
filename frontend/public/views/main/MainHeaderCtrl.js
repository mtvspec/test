(function () {
  'use strict';

  angular.module('app')
  .controller('MainHeaderCtrl', function ($mdDialog, ProjectModel) {
    var vm = this;

    vm.showProjectCharter = showProjectCharter;
    function showProjectCharter(ev) {
      vm.projectID = ProjectModel.getSelectedProjectID();
      $mdDialog.show({
  			templateUrl: 'views/main/projects/project/charter/projectCharterTmpl.html',
  			controller: 'ProjectCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false,
        locals: vm.projectID,
        data: {
          title: 'Устав проекта'
        }
      })
      .then(function () {
        // on success
      }, function () {
        // on failure
      });
    };

    vm.showProjectMembers = showProjectMembers;
    function showProjectMembers(ev) {
      vm.projectID = ProjectModel.getSelectedProjectID();
      $mdDialog.show({
  			templateUrl: 'views/main/projects/project/members/projectMembersTmpl.html',
  			controller: 'ProjectCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false,
        locals: vm.projectID
      })
      .then(function () {
        // on success
      }, function () {
        // on failure
      });
    };

  });

})();
