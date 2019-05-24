var successModalTemplateUrl = require('./success-modal.html');
var InterestCtrl = function($scope, $timeout, $uibModal, interest, userInterests, users, UserInterest, Hail) {
  var vm = this;

  vm.interest = interest.data;
  vm.userInterests = userInterests.data;
  vm.users = users.data;
  vm.category = $scope.categories.filter(function(c){
    return c.id == vm.interest.category_id
  })[0];

  vm.hail = function(user){
    vm.hailingUser = user
    Hail.save({hail: {to_user_id: user.id, message: "Hail from an interest or answer, let's chat"}}).then(function(){
      $uibModal.open({
        scope: $scope,
        templateUrl: successModalTemplateUrl,
        windowClass: 'center-modal',
        backdropClass: 'no-click'
      });
    }).catch(function (err) {});
  };
};

InterestCtrl.$inject = ['$scope', '$timeout', '$uibModal', 'interest', 'userInterests', 'users', 'UserInterest', 'Hail'];

export default InterestCtrl;
