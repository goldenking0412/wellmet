var BannerManagement = function($http){
  this.query = function(){
    return $http({ url: '/banner_managements' });
  };
};
BannerManagement.$inject = ['$http'];

export default BannerManagement;
