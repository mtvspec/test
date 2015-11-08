(function () {
  'use strict';
  
  angular.module('app', ['ui.router', 'ngMaterial'])
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
    
    .state('admin', {
      abstract: true,
      templateUrl: 'views/root.html'
    })
    
    .state('admin.layout', {
      views: {
        header: {
          templateUrl: 'views/admin/header.html'
        },
        content: {
          templateUrl: 'views/admin/content.html'
        }
      },
      data: {
        title: 'Телефонный справочник'
      }
    })
    
    .state('admin.layout.pers', {
      url: '/pers',
      templateUrl: 'views/admin/persons/allPersons/AllPersonsTmpl.html',
      controller: 'PersonsCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Физические лица'
      }
    })
    
    .state('admin.layout.companies', {
      url: '/companies',
      templateUrl: 'views/admin/companies/allCompanies/AllCompaniesTmpl.html',
      controller: 'CompaniesCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Юридические лица'
      }
    })
    
    .state('admin.layout.person', {
      url: '/person',
      templateUrl: 'views/test/person/add/person.html',
      controller: 'PersonCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Физическое лицо'
      }
    })
    
    .state('admin.layout.persons', {
      url: '/persons',
      templateUrl: 'views/test/person/all/persons.html',
      controller: 'PersonsCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Физические лица'
      }
    })
    
  });
})();