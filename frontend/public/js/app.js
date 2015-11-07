(function () {
  'use strict';
  
  angular.module('app', ['ui.router'])
  .run(function ($rootScope) {
    $rootScope.$on('$stateChangeSuccess', function (evt, toState) {
      if (toState.data && toState.data.title) {
        $rootScope.APP_TITLE = toState.data.title;
      } else {
        throw new Error('No title specified in state "' + toState.name + '"');
      }
    })
  })
  .config(function ($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');
    
    $stateProvider
    .state('persons', {
      url: '/persons',
      templateUrl: 'views/persons/allPersons/AllPersonsTmpl.html',
      controller: 'PersonsCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Физические лица'
      }
    })
  })
})();