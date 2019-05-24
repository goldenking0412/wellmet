var Page = function($http){
  this.get = function(id, params){
    return $http({
      url: '/pages/' + id,
      params: params
    });
  };

  this.query = function(params){
    return $http({
      url: '/pages',
      params: params
    });
  };

  this.update = function(id, params){
    return $http({
      url: '/pages/' + id,
      data: params,
      method: 'PUT'
    });
  };

  this.save = function(params) {
    return $http({
      url: '/pages',
      data: params,
      method: 'POST'
    });
  };

  this.destroy = function(id, params) {
    return $http({
      url: '/pages/' + id,
      params: params,
      method: 'DELETE'
    });
  };
};

Page.$inject = ['$http'];

export default Page;
