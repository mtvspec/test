(function () {
  'use strict';

  angular.module('app')
  .factory('UserModel', function ($http) {
    var User = {},
    url = '/api/users/login';
    return {
      authentificateUser: function authentificateUser(user) {
        return $http({
          method: 'POST',
          url: url,
          data: user
        }).then(function (response) {
          User = response.data;
          return response.data;
        }, function (response) {
          console.error(response.status.statusText);
          return false;
        });
      },
      getUser: function getUser() {
        if (User) {
          return User;
        } else {
          return null;
        }
      }
    }
  });
})();
