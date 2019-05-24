var Answer = function($http){
  this.query = function(params){
    return $http({
      url: '/answers',
      params: params
    });
  };

  this.update = function(id, params){
    return $http({
      url: '/answers/' + id,
      method: 'PUT',
      data: params
    });
  };

  this.save = function(params) {
    return $http({
      url: '/answers',
      method: 'POST',
      data: params
    });
  };

  this.delete = function(id) {
    return $http({
      url: '/answers/' + id,
      method: 'DELETE'
    });
  };
};

Answer.$inject = ['$http'];

export default Answer;
