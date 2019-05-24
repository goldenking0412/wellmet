var Hail = function($http){
  this.query = function(params) {
    return $http({
      url: '/hails',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/hails',
      data: params,
      method: 'POST'
    });
  };

  this.update = function(id, params){
    return $http({
      url: '/hails/' + id,
      data: params,
      method: 'PUT'
    });
  };

  this.destroy = function(id){
    return $http({
      url: '/hails/' + id,
      method: 'DELETE'
    });
  };
};

Hail.$inject = ['$http'];

export default Hail
