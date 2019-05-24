var Category = function($http){
  this.query = function(){
    return $http({ url: '/categories' });
  };
};
Category.$inject = ['$http'];

export default Category;
