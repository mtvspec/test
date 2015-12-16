(function () {
  'use strict';

  angular.module('app')
  .controller('RemarkObjectAddCtrl', function ($http, $mdDialog) {

    var vm = this,
    _remarksObjectsUrl = '/api/objects',
    remarkObjectAddForm = {},
    remarkObject = {};
    vm.remarkObjectAddForm = remarkObjectAddForm,
    vm.remarkObject = remarkObject;

    vm.hasError = hasError;
    function hasError(fieldName){
      var field = projectResultAddForm[fieldName];
      if(field){
        return field.$invalid && (projectResultAddForm.$submitted || !field.$pristine);
      }
    };

    vm.submit = submit;
    function submit(data){
      console.log(data);
      vm.remarkObjectAddForm.$setSubmitted();
      if(vm.remarkObjectAddForm.$valid){
        $http({
          method: 'POST',
          url: _remarksObjectsUrl,
          data: data
        }, function (response) {
          if (response.status === 201) {
            data.id = response.data.id;
          }
          vm.closeDialog();
        }, function (response) {
          console.log(response.status.statusText);
        });
      }
    };

    vm.closeDialog = closeDialog;
    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });

})();
