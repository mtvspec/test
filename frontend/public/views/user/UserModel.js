(function () {
  'use strict';

  angular.module('app')
  .factory('UserModel', function ($http) {
    var User = {},
    roles = [],
    _authentificateUserUrl = '/api/users/login',
    _authoriseUserUrl = '/api/users/authorise/';
    return {
      authentificateUser: function authentificateUser(user) {
        return $http({
          method: 'POST',
          url: _authentificateUserUrl,
          data: {
            lang: 'ru',
            user
          }
        }).then(function (response) {
          console.log(response);
          User = response.data;
          return response.data;
        }, function (response) {
          console.error(response);
          return false;
        });
      },
      getUser: function getUser() {
        if (User) {
          return User;
        } else {
          return null;
        }
      },
      authoriseUser: function authoriseUser(userID) {
        return $http({
          method: 'GET',
          url: _authoriseUserUrl + userID,
          params: {
            lang: 'ru'
          }
        }).then(function (response) {
          console.log(response);
          roles = response.data;
          return roles;
        }, function (response) {
          console.error(response);
          return false;
        })
      }
    }
  });
})();
