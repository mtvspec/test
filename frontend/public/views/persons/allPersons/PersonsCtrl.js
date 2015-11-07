(function () {
  'use strict';
  
  angular.module('app')
  .controller('PersonsCtrl', function () {
    var vm = this;
    vm.persons = [
      {
        firstName: 'Куралай'
      }
    ]
  });
})();