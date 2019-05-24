var profileImage = function($rootScope) {
  return function (categoryId) {
    var category = $rootScope.categories.filter(function(c){
      return c.id === categoryId;
    })[0];
    return "/images/user/" + category.image;
  };
};

profileImage.$inject = ['$rootScope'];

export default profileImage;