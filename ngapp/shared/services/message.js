var Message = function($http){
  this.query = function(params) {
    return $http({
      url: '/messages',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/messages',
      method: 'POST',
      data: params
    });
  };

  this.deleteAll = function(params){
    return $http({
      url: '/messages/destroy_all',
      method: 'DELETE',
      params: params
    });
  };
};

Message.$inject = ['$http'];

export default Message;
