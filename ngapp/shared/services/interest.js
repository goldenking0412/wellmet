var Interest = function($http){
  this.query = function(params){
    return $http({
      url: '/interests',
      params: params
    });
  };

  this.get = function(id, params){
    return $http({
      url: '/interests/' + id,
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/interests',
      data: params,
      method: 'POST'
    })
  }
};

Interest.$inject = ['$http'];

export default Interest;
