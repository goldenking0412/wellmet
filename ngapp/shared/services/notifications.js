var Notification = function($http){
  this.query = function(params){
    return $http({
      url: '/notifications',
      params: params
    });
  };
};

Notification.$inject = ['$http'];

export default Notification;
