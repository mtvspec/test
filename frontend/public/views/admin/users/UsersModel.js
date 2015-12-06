(function () {
  'use strict';

  angular.module('app')
  .factory('UsersModel', function ($http) {
    var Users = [],
    url = '/api/users/';
    return {
      retrieveUsers: function retrieveUsers() {
        return $http({
          method: 'GET',
          url: url
        }).then(function (response) {
          console.log(response.data);
          Users = response.data;
          return response.data;
        }, function (response) {
          console.error(response.status.statusText);
          return false;
        });
      },
      getUsers: function getUser() {
        if (Users) {
          return Users;
        } else {
          Users = retrieveUsers();
          return Users;
        }
      }
    }
  });
})();
