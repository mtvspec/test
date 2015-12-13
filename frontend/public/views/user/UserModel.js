(function () {
  'use strict';

  angular.module('app')
  .factory('UserModel', function ($http) {
    var User = {},
    roles = [],
    _authentificateUserUrl = '/api/users/authentificate/',
    _authoriseUserUrl = '/api/users/authorise/';
    return {
      authentificateUser: function authentificateUser(user) {
        return $http({
          method: 'POST',
          url: _authentificateUserUrl,
          data: {
            user
          }
        }).then(function (response) {
          console.log(response.status, response.statusText, response.data);
          return User = response.data;
        }, function (response) {
          console.info(user);
          console.error(response.status, response.statusText, response.data);
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
          url: _authoriseUserUrl + userID
        }).then(function (response) {
          console.log(response);
          roles = response.data;
          return roles;
        }, function (response) {
          console.info('userID:', userID);
          console.error(response.status, response.statusText, response.data);
          return false;
        })
      },
      openSession: function openSession(user) {
        return $http({
          method: 'POST',
          url: 'api/users/open-session',
          data: {
            user
          }
        }).then(function (response) {
          console.log(response);
          if (response.status === 201) {
            console.log(response);
          }
        }, function (response) {
          console.log(response);
        });
      }
    }
  });
})();
