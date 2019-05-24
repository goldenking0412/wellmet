var UserInterest = function($http){
  this.query = function(params){
    return $http({
      url: '/user_interests',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/user_interests',
      data: params,
      method: 'POST'
    });
  };

  this.destroy = function(id){
    return $http({
      url: '/user_interests/' + id,
      method: 'DELETE'
    })
  }
};

UserInterest.$inject = ['$http'];

export default UserInterest;
