(function () {
  'use strict';

  angular.module('app')
  .factory('ProjectModel', function () {
    return {
      getSelectedProjectID: function getSelectedProjectID() {
        return this.selectedProjectID;
      },
      setSelectedProjectID: function setSelectedProjectID(id) {
        this.selectedProjectID = id;
      }
    }
  });
})();
