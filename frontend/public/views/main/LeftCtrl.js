(function () {
  'use strict';

  angular.module('app')
  .controller('LeftCtrl', function($state, $http, $mdDialog) {

    var vm = this,
    _url = '/api/projects',
    projects = [],
    activeProject;
    vm.projects = projects;

    $http({
      method: 'GET',
      url: _url
    }).then(function (response) {
      return vm.projects = response.data;
    }, function (response) {
      console.error(response.status.statusText);
    });

    vm.showProjectID = showProjectID;
    function showProjectID(id) {
      activeProject = id;
      console.log(activeProject);
    };

    vm.sendSelectedProjectID = sendSelectedProjectID;
    function sendSelectedProjectID(id) {
      $state.go('main.layout.project', {id: id});
    };

    vm.addProject = addProject;
    function addProject(ev) {
      $mdDialog.show({
  			templateUrl: 'views/main/projects/addProject/addProjectTmpl.html',
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
