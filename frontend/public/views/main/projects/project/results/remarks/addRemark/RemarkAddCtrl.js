(function () {
  'use strict';

  angular.module('app')
  .controller('RemarkAddCtrl', function ($http, $mdDialog) {
    var vm = this,
    _remarksUrl = '/api/remarks',
    _remarksObjectsUrl = '/api/objects',
    _remarksStatusesUrl = '/api/dict/remark-statuses',
    _personsUrl = '/api/persons',
    remarkAddForm = {},
    objects = [],
    persons = [];
    vm.objects = objects,
    vm.remarkAddForm = remarkAddForm;

    vm.loadRemarksObjects = loadRemarksObjects;
    function loadRemarksObjects() {
      $http({
        method: 'GET',
        url: _remarksObjectsUrl
      }).then(function (response) {
        vm.objects = response.data;
      }, function (response) {
        console.log(response.status.statusText);
      });
    };

    vm.loadRemarksStatuses = loadRemarksStatuses;
    function loadRemarksStatuses() {
      $http({
        method: 'GET',
        url: _remarksStatusesUrl
      }).then(function (response) {
        vm.remarkStatuses = response.data;
      }, function (response) {
        console.log(response.status.statusText);
      });
    };

    vm.loadPersons = loadPersons;
    function loadPersons() {
      $http({
        method: 'GET',
        url: _personsUrl
      }).then(function (response) {
        if (response.status === 200) {
          vm.persons = response.data;
        }
      });
    };

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = projectResultAddForm[fieldName];
			if(field){
				return field.$invalid && (projectResultAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
		function submit(data){
			vm.remarkAddForm.$setSubmitted();
			if(vm.remarkAddForm.$valid){
				$http({
          method: 'POST',
          url: _remarksUrl,
          data: data
        }).then(function (response) {
          if (response.status == 201) {
            data.id = response.data.id;
            $mdDialog.hide(data);
          }
        }, function (response) {
          console.log(response.status.statusText);
        });
			}
		};

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });

})();
