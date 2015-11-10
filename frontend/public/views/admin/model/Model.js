(function () {
  'use strict';

  angular.module('app')
  .factory('Model', function ($http) {

    function LTModel() {
    };

    LTModel.prototype.getObjects = function getObjects(config) {
      return $http({
        method: config.method,
        url: config.url
      }).then(function (response) {
        if (response.status === 200) {
          return response.data;
        } else if (response.status === 204) {
          return [];
        } else {
          return null;
        }
      }, function (response) {
        console.error(response.status.statusText);
        return null;
      });

    };

    LTModel.prototype.getObject = function getObject(config) {
      return $http({
        method: config.method,
        url: config.url,
        params: config.data.id
      }).then(function (response) {
        if (response.status === 200 && config.data.id === Number(response.data.id)) {
          return response.data;
        } else if (response.status === 204) {
          return {};
        } else if (response.status === 400) {
          return response.data;
        } else {
          return null;
        }
        return response.data;
      }, function (response) {
        console.error(response.status.statusText);
        return null;
      });
    };

    LTModel.prototype.createObject = function createObject(config) {
      return $http({
        method: config.method,
        url: config.url,
        data: config.data
      }).then(function (response) {
        if (response.status === 201 && Number(response.data.id) > 0) {
          return response;
        } else {
          return response;
        }
      }, function (response) {
        console.error(response.status.statusText);
        return null;
      });
    };

    LTModel.prototype.updateObject = function updateObject(config) {
      return $http({
        method: config.method,
        url: config.url,
        params: config.data.id,
        data: config.data
      }).then(function (response) {
        if (response.status === 200 && config.data.id === Number(response.status.id)) {
          return response.data;
        } else if (response.status === 204) {
          return {};
        } else if (response.status === 400) {
          return response.data;
        } else {
          return null;
        }
      }, function (response) {
        console.error(response.status.statusText);
        return null;
      });
    };

    LTModel.prototype.deleteObject = function deleteObject(config) {
      return $http({
        method: config.method,
        url: config.url,
        params: config.data.id
      }).then(function (response) {
        if (response.status === 200 && config.data.id === Number(response.data.id)) {
          return response.data;
        } else if (response.status === 204) {
          return {};
        } else if (response.status === 400) {
          return response.data;
        } else {
          return null;
        }
      }, function (response) {
        console.error(response.status.statusText);
        return null;
      });
    };

    return LTModel;

  });

})();
