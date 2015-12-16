(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectsCtrl', function($http) {

    var vm = this,
    _url = '/api/projects',
    projects = [];
    vm.projects = projects;

    $http({
      method: 'GET',
      url: _url
    }).then(function (response) {
      return vm.projects = response.data;
    }, function (response) {
      console.error(response.status.statusText);
    });

  });

})();
