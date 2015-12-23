(function () {
  'use strict';

  angular.module('app')
  .factory('ProjectsResultsModel', function ($http) {
    var _url = '/api/projects/',
    _results = [];

    return {
      createResult: function createResult(projectID, data) {
        $http({
          method: 'POST',
          url: _url + projectID + '/results',
          data: data
        }).then(function (response) {
          console.info(response.data);
          if (response.status === 201) {
            data.id = response.data.id;
            _results.push(data);
          }
          return response.status;
        }, function (response) {
          console.error(response.status, response.statusText, response.data);
        });
      },
      retrieveProjectResults: function retrieveProjectResults(projectID) {
        return $http({
          method: 'GET',
          url: _url + projectID + '/results'
        }).then(function (response) {
          console.info(response.data);
          if (response.status === 200) {
            for (var i = 0; i < response.data.length; i++) {
              _results.push(response.data[i]);
            }
            return _results;
          }
        }, function (response) {
          console.error(response.status, response.statusText, response.data);
        });
      },
      getProjectResults: function getProjectResults() {
        // body...
      }
    }
  });

})();
