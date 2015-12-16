(function () {
  'use strict';

  angular.module('app')
  .controller('RemarksCtrl', function ($http, $mdDialog) {
    var vm = this,
    _remarksUrl = '/api/remarks',
    _remarksObjectsUrl = '/api/objects',
    remarks = [],
    objects = [];
    vm.remarks = remarks,
    vm.objects = objects;

    vm.remarks = getRemarks();

    function getRemarks() {
      $http({
        method: 'GET',
        url: _remarksUrl
      }).then(function (response) {
        return response.data;
      }, function (response) {
        console.error(response.status.statusText);
      });
    };

    $http({
      method: 'GET',
      url: _remarksObjectsUrl
    }).then(function (response) {
      vm.objects = response.data;
    }, function (response) {
      console.error(response.status.statusText);
    });

    vm.filterObjects = filterObjects;
    function filterObjects(obj, id) {
      var filteredObjects = [];
      for (var i = 0; i < obj.length; i++) {
        if (obj[i].objectID === id) {
          filteredObjects.push(obj[i]);
        }
      }
      return filteredObjects;
    };

    vm.addRemark = addRemark;
    function addRemark(ev) {
      $mdDialog.show({
  			templateUrl: 'views/main/projects/project/results/remarks/addRemark/addRemarkTmpl.html',
  			controller: 'RemarkAddCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false
      })
      .then(function (data) {
        vm.remarks.push(data);
        console.log(vm.remarks);
        // on success
      }, function (response) {
        console.log(response);
        // on failure
      });
    };

    vm.addRemarkObject = addRemarkObject;
    function addRemarkObject(ev) {
      $mdDialog.show({
  			templateUrl: 'views/main/projects/project/objects/addRemarkObject/addRemarkObjectTmpl.html',
  			controller: 'RemarkObjectAddCtrl',
        controllerAs: 'vm',
        targetEvent: ev,
        clickOutsideToClose: false
      })
      .then(function (data) {
        // on success
      }, function (response) {
        console.log(response);
        // on failure
      });
    };

  });

})();
