(function () {
  'use strict';

  angular.module('app', ['ui.router', 'ngMaterial', 'ngMessages'])
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

    .state('login', {
      url: '/login',
      templateUrl: 'views/login/loginTmpl.html',
      controller: 'LoginCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Authentification'
      }
    })

    .state('main', {
      abstract: true,
      templateUrl: 'views/root.html'
    })

    .state('main.layout', {
      views: {
        header: {
          templateUrl: 'views/main/header.html'
        },
        left: {
          templateUrl: 'views/main/left.html',
          controller: 'LeftCtrl',
          controllerAs: 'vm'
        },
        content: {
          templateUrl: 'views/main/content.html'
        },
        right: {
          templateUrl: 'views/main/right.html'
        },
        footer: {
          templateUrl: 'views/main/footer.html'
        }
      },
      data: {
        title: 'Open Project'
      }
    })

    .state('main.layout.projects', {
      url: '/projects',
      templateUrl: 'views/main/projects/allProjects/allProjectsTmpl.html',
      controller: 'ProjectsCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Проекты'
      }
    })

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

    .state('admin.layout.persons', {
      url: '/admin/persons',
      templateUrl: 'views/admin/persons/allPersons/AllPersonsTmpl.html',
      controller: 'PersonsCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Физические лица'
      }
    })

    .state('admin.layout.companies', {
      url: '/comps',
      templateUrl: 'views/admin/companies/allCompanies/AllCompaniesTmpl.html',
      controller: 'CompaniesCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Юридические лица'
      }
    })

    .state('companies', {
      url: '/companies',
      templateUrl: 'views/test/company/all/companies.html',
      controller: 'CompaniesCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Юридические лица'
      }
    })

    .state('addCompany', {
      url: '/addCompany',
      templateUrl: 'views/admin/companies/addCompany/addCompanyTmpl.html',
      controller: 'ContactsAddController',
      controllerAs: 'vm',
      data: {
        title: 'Добавление ЮЛ'
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

    .state('admin.layout.pers', {
      url: '/pers',
      templateUrl: 'views/test/person/all/persons.html',
      controller: 'PersonsCtrl',
      controllerAs: 'vm',
      data: {
        title: 'Физические лица'
      }
    })

  });
})();
