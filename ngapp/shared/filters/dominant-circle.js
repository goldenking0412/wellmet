var profileImageColor = function($rootScope) {
  return function (categoryId) {
    var category = $rootScope.categories.filter(function(c){
      return c.id === categoryId;
    })[0];
    if (category) {
        return category.color;
    }
    else {
        return "black";
    }
  };
};

profileImageColor.$inject = ['$rootScope'];

export default profileImageColor;