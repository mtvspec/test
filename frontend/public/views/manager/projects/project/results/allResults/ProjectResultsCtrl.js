(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectResultsCtrl', function($http, ProjectModel, ProjectsResultsModel) {
    console.log('project results ctrl');

    var vm = this,
    projectID = ProjectModel.getSelectedProjectID();

    ProjectsResultsModel.retrieveProjectResults(projectID).then(function (results) {
      vm.results = results;
    });

  });

})();
