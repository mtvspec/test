(function () {
  'use strict';

  angular.module('app')
  .factory('ProjectsModel', function ($http) {
    var _projects = [],
    _url = '/api/projects';

    $http({
      method: 'GET',
      url: _url
    }).then(function (response) {
      if (response.status === 200) {
        for (var i = 0; i < response.data.length; i++) {
          _projects.push(response.data[i]);
        }
      }
    }, function (response) {
      console.error(response.status, response.statusText, response.data);
    });

    return {
      createProject: function createProject(data) {
        return $http({
          method: 'POST',
          url: _url,
          data: data
        }).then(function (response) {
          console.log(response);
          if (response.status === 201) {
            data.id = response.data.id;
            _projects.push(data);
            return response.status;
          }
        }, function (response) {
          console.error(response.status, response.statusText, response.data);
        });
      },
      getProjects: function getProjects() {
        console.log(_projects);
        return _projects;
      }
    }

  });
})();
