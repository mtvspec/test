(function () {
  'use strict';

  angular.module('app')
  .controller('ProjectResultsCtrl', function($http) {

    var vm = this,
    _url = '/api/projects/:id/results',
    results = [];
    vm.results = results;

    $http({
      method: 'GET',
      url: _url,
      params: 1
    }).then(function (response) {
      return vm.results = response.data;
    }, function (response) {
      console.error(response.status.statusText);
    });

  });

})();
