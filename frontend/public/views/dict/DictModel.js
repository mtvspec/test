(function () {
  'use strict';

  angular.module('app')
  .factory('DictModel', function ($http) {
    var _url = '/api/dict/project-result-types',
    _types = [];

    return {
      retrieveResultTypes: function retrieveResultTypes() {
        $http({
          method: 'GET',
          url: _url
        }).then(function (response) {
          console.log(response.data);
          if (response.status === 200) {
            for (var i = 0; i < response.data.length; i++) {
              _types.push(response.data[i]);
            }
          }
        }, function (response) {
          console.error(response.status, response.statusText);
        })
      },
      getResultTypes: function getResultTypes() {
        return _types;
      }
    }
  });

})();
