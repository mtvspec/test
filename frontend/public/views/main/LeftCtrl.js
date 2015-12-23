(function () {
  'use strict';

  angular.module('app')
  .controller('LeftCtrl', function($state, $http, $mdDialog, ProjectModel, ProjectsModel) {

    var vm = this;
    vm.projects = ProjectsModel.getProjects();

    vm.sendSelectedProjectID = sendSelectedProjectID;
    function sendSelectedProjectID(id) {
      ProjectModel.setSelectedProjectID(id);
      $state.go('main.layout.project', {id: id});
    };

  });

})();
