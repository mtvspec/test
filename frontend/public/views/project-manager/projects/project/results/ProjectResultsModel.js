(function () {
  'use strict';

  angular.module('app')
  .factory('ProjectResultsModel', function ($http) {
    var _url = '/api/projects/',
    _results = [];

    return {
      createProjectResult: function createProjectResult(projectID, data) {
        return $http({
          method: 'POST',
          url: _url + projectID + '/results',
          data: data
        }).then(function (response) {
          console.info(response);
          if (response.status === 201) {
            _results.push({
              id: response.data.id,
              typeID: data.typeID,
              resultName: data.resultName,
              parentID: data.parentID,
              authorID: data.authorID,
              responsiblePersonID: data.responsiblePersonID,
            });
            return response.status;
          }
        }, function (response) {
          console.error(response.status, response.statusText, response.data);
        });
      },
      getProjectResults: function getProjectResults(projectID) {
        return $http({
          method: 'GET',
          url: _url + projectID + '/results'
        }).then(function (response) {
          console.info(response);
          for (var i = 0; i < response.data.length; i++) {
            _results.push(response.data[i]);
          }
          return _results;
        }, function (response) {
          console.error(response.status.statusText);
        });
      }
    }
  });
})();
