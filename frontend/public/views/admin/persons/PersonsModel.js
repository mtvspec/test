(function(){
	'use strict';

	angular.module('app')
	.factory('PersonsModel', PersonsModel);

	function PersonsModel($http){

		var _url = '/api/persons/',
    _gendersUrl = '/api/dict/genders',
    _persons = [],
    _genders = [],
		_personsPromise;

    $http({
      method: 'GET',
      url: _gendersUrl
    }).then(function (response) {
      for (var i = 0; i < response.data.length; i++) {
        _genders.push(response.data[i]);
      }
      return _genders;
    }, function (response) {
      console.error('Load person genders:', response.status, response.statusText);
    });

    $http({
      method: 'GET',
      url: _url
    }).then(function (response) {
      for (var i = 0; i < response.data.length; i++) {
        _persons.push(response.data[i]);
      }
      return _persons;
    }, function (response) {
      console.error('Load persons:', response.status, response.statusText);
    });

		return {
			createPerson: function createPerson(data) {
        console.log(data);
				return $http({
					method: 'POST',
					url: _url,
					data: data
				}).then(function(response){
					console.log('Create:', response.data);
          if (response.status === 201) {
            data.id = response.data.id;
  					_persons.push(data);
            return response.status;
          }
				}, function (response) {
				  console.error('Create person:', response.status, response.statusText, response.data);
				});
			},
      createPerson$: function createPerson$(id, data) {
        return $http({
          method: 'POST',
          url: '/api/companies/' + id + '/persons',
          data: data
        }).then(function (response) {
          console.info('Create:', response.data);
          if (response.status === 201) {
            data.id = response.data.id;
            _persons$.push(data);
            return response.status;
          }
        }, function (response) {
          console.error('Create person$:', response.status, response.statusText, response.data);
        });
      },
      getPersons: function getPersons() {
        return _persons;
      },
      getGenders: function getGenders() {
        return _genders;
      },
			readPersons: function(){
				return $http({
					method: 'GET',
					url: _url
				}).then(function (response) {
          console.log(response);
					return response.data;
				})
			},
			savePerson: function(data){
				return $http({
					method: 'PUT',
					url: _url + data.id,
					data: data
				}).then(function(response){
          console.log('Update:', response.data);
					var i, len;
					for(i = 0, len = _persons.length; i < len; i++){
						if(_persons[i].id === data.id){
              _persons[i].lastName = data.lastName;
							_persons[i].firstName = data.firstName;
              _persons[i].middleName = data.middleName;
              _persons[i].dob = data.dob;
              _persons[i].genderID = data.genderID;
							break;
						}
					}
				}, function(response){
					console.error('UPDATE person:', response.status, response.statusText);
				});
			},
			removePerson: function(data){
				console.log('Remove:', data);
				return $http({
					method: 'DELETE',
					url: _url + data.id
				}).then(function(){
					var i, len;
					for(i = 0, len = _persons.length; i < len; i++){
						if(_persons[i].id === data.id){
							_persons.splice(i, 1);
							break;
						}
					}
				}, function(response){
					console.error('DELETE person:', response.status, response.statusText);
				})
			},
			readPerson: function(data){
				return $http({
					method: 'GET',
					url: _url + data.id
				}).then(function (response) {
          console.log(response);
					return response.data;
				}, function(response){
          console.info('Person ID:', data.id);
					console.error('GET person:', response.status, response.statusText);
				})
			},
			readAllPersons: function readAllPersons(user){
				if(_personsPromise){
					return _personsPromise;
				} else {
					_personsPromise = $http({
						method: 'GET',
						url: _url
					}).then(function(response){
						var i, len;
						for (i = 0, len = response.data.length; i < len; i++){
							_persons.push(response.data[i]);
						}
						return _persons;
					}, function(response){
						if (Number(response.status) === 401) {
							return _error;
						}
					});
					return _personsPromise;
				}
			}
		};
	}
})();
