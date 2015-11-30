(function () {
  'use strict';

  angular.module('app')
  .controller('MainHeaderCtrl', function ($http) {
    var vm = this;

    vm.showProjectCharter = showProjectCharter;
    function showProjectCharter(id) {
      console.log(id);
    };

  });

})();
