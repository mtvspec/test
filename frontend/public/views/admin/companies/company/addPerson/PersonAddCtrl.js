(function () {
  'use strict';

  angular.module('app')
  .controller('Person$AddCtrl', function ($mdDialog, PersonsModel, locals) {
    var vm = this;
    vm.id = locals.id,
    vm.person = {},
    vm.genders = PersonsModel.getGenders();

    vm.hasError = hasError;
		function hasError(fieldName){
			var field = companyAddForm[fieldName];
			if(field){
				return field.$invalid && (companyAddForm.$submitted || !field.$pristine);
			}
		};

    vm.submit = submit;
    function submit(id, data) {
      vm.personAddForm.$setSubmitted();
			if(vm.personAddForm.$valid){
        PersonsModel.createPerson$(id, data).then(function (status) {
          if (status === 201) {
            $mdDialog.hide();
          }
        });
			}
    };

    vm.closeDialog = closeDialog;
    function closeDialog() {
      $mdDialog.cancel();
    };

  });
})();
