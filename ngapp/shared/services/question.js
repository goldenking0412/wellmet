var Question = function($http){
  this.query = function(params){
    return $http({
      url: '/questions',
      params: params
    });
  };

  this.save = function(params){
    return $http({
      url: '/questions',
      data: params,
      method: 'POST'
    });
  };

  this.delete = function(id) {
    return $http({
      url: '/questions/' + id,
      method: 'DELETE'
    });
  };
};

Question.$inject = ['$http'];

export default Question;
