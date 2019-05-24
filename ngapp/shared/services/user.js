var User = function($http){
  this.get = function(id, params){
    return $http({
      url: '/users/' + id,
      params: params
    });
  };

  this.query = function(params){
    return $http({
      url: '/users',
      params: params
    });
  };

  this.update = function(id, params){
    return $http({
      url: '/users/' + id,
      data: params,
      method: 'PUT'
    });
  };

  this.save = function(params) {
    return $http({
      url: '/users',
      data: params,
      method: 'POST'
    });
  };

  this.destroy = function(id, params) {
    return $http({
      url: '/users/' + id,
      params: params,
      method: 'DELETE'
    });
  };
};

User.$inject = ['$http'];

export default User;
