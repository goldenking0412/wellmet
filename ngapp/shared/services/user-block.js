var UserBlock = function($http){
  this.query = function(params){
    return $http({
      url: '/user_blocks',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/user_blocks',
      data: params,
      method: 'POST'
    });
  };

  this.destroy = function(id){
    return $http({
      url: '/user_blocks/' + id,
      method: 'DELETE'
    })
  }
};

UserBlock.$inject = ['$http'];

export default UserBlock;
