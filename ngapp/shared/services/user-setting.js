var UserSetting = function($http){
  this.query = function(params){
    return $http({
      url: '/user_settings',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/user_settings',
      data: params,
      method: 'POST'
    });
  };
};

UserSetting.$inject = ['$http'];

export default UserSetting;
