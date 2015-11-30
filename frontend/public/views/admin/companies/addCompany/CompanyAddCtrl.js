(function () {
  'use strict';

  angular.module('app')
  .controller('CompanyAddCtrl', function ($http, $mdDialog) {
    var vm = this,
    url = '/api/companies',
    companyAddForm = {},
    company = {};
    vm.company = company;

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = companyAddForm[fieldName];
			if(field){
				return field.$invalid && (companyAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
    function submit(data) {
      console.log(data);
      $http({
        method: 'POST',
        url: url,
        data: data
      }).then(function (response) {
        if (response.status === 201) {
          data.id = response.data.id;
          $mdDialog.hide();
        }
      }, function (response) {
        console.error(response.status.statusText);
        $mdDialog.cancel();
      });
    };

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });

})();
