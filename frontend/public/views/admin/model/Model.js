(function () {
  'use strict';

  angular.module('app')
  .factory('Model', function ($http) {

    function LTModel() {
    };

    LTModel.prototype.getObjects = function getObjects(config, cb) {
      return $http({
        method: 'GET',
        url: config.url
      })
      .then(function (response) {
        if (response.status === 200) {
          return cb(response.status, response.data);
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
      for (var i = 0, len = config.data.objects.length; i < len; i++) {
        if (config.data.objects[i].id == config.params.id) {
          config.data = config.data.objects[i];
          return config;
          break;
        }
      }
    };

    LTModel.prototype.createObject = function createObject(config) {
      return $http({
        method: 'POST',
        url: config.url,
        data: config.data
      })
      .then(function(response){
        if (response.status === 201) {
          config.data.id = response.data.id;
          config.data.objects.push(config.data);
        } else {
          return config.data.objects;
        }
      });
    };

    LTModel.prototype.updateObject = function updateObject(config) {
      return $http({
        method: 'PUT',
        url: config.url,
        params: config.data.id,
        data: config.data
      })
      .then(function (response) {
        if (response.status === 200 && config.data.id === Number(response.status.id)) {
          return response.data;
        } else if (response.status === 204) {
          return {};
        } else if (response.status === 400) {
          return response.data;
        } else {
          return response;
        }
      }, function (response) {
        console.error(response.status.statusText);
        return null;
      });
    };

    LTModel.prototype.deleteObject = function deleteObject(config) {
      return $http({
        method: 'DELETE',
        url: config.url,
        params: config.data.id
      })
      .then(function (response) {
        if (response.status === 200 && config.data.id === Number(response.data.id)) {
          for(var i = 0, len = config.data.objects.length; i < len; i++){
						if(config.data.objects[i].id === data.id){
							config.data.objects.splice(i, 1);
							break;
						}
					}
          return config.data.objects = _objects;
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

    LTModel.prototype.getAllObjects = function getAllObjects(config) {
      console.log(config);
      if(config.data.objectsPromise){
        console.log('promise');
        return config.data.objectsPromise;
      } else {
        config.data.objectsPromise = $http({
          method: 'GET',
          url: config.url
        })
        .then(function(response){
          console.log(response.data);
          for (var i = 0, len = response.data.length; i < len; i++){
            config.data.objects.push(response.data[i]);
          }
          return config.data.objects;
        }, function(response){
          if (Number(response.status) === 401) {
            return _error;
          }
        });
        return config.data.objectsPromise;
      }
    };

    return LTModel;

  });

})();
