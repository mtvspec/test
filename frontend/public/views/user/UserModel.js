(function () {
  'use strict';

  angular.module('app')
  .factory('UserModel', function ($http, $state) {
    var User = {},
    session,
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
      getSession: function getSession() {
        if (session) {
          return session;
        } else {
          return null;
        }
      },
      openSession: function openSession(user) {
        return $http({
          method: 'POST',
          url: 'api/users/open-session',
          data: {
            user
          }
        }).then(function (response) {
          if (response.status === 201) {
            session = response.data;
          } else {
            $state.go('login');
          }
        }, function (response) {
          console.info(user);
          console.error(response.status, response.statusText, response.data);
        });
      }
    }
  });
})();
