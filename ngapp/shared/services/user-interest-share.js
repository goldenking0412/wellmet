var UserInterestShare = function($http){
  this.query = function(params){
    return $http({
      url: '/user_interest_shares',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/user_interest_shares',
      data: params,
      method: 'POST'
    });
  };

  this.destroy = function(id){
    return $http({
      url: '/user_interest_shares/' + id,
      method: 'DELETE'
    })
  }
};

UserInterestShare.$inject = ['$http'];

export default UserInterestShare;
