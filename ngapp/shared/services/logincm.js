var Logincm = function($http){
  this.query = function(){
    return $http({ url: '/logincms' });
  };
};
Logincm.$inject = ['$http'];

export default Logincm;