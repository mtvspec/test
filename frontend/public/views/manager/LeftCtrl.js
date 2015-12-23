(function () {
  'use strict';

  angular.module('app')
  .controller('LeftCtrl', function($state, $http, $mdDialog, ProjectModel, ProjectsModel) {

    var vm = this;
    vm.projects = ProjectsModel.getProjects();

    vm.sendSelectedProjectID = sendSelectedProjectID;
    function sendSelectedProjectID(id) {
      ProjectModel.setSelectedProjectID(id);
      $state.go('manager.layout.project', {id: id});
    };

    vm.addProject = addProject;
    function addProject(ev) {
      $mdDialog.show({
  			templateUrl: 'views/manager/projects/addProject/addProjectTmpl.html',
  			controller: 'ProjectAddCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false
      })
      .then(function (response) {
        console.log(response);
      }, function (response) {
        // body...
      });
    };

  });

})();
