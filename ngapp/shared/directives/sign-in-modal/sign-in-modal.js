var templateUrl = require('./sign-in-modal.html');

var SignInModalInstanceCtrl = function($uibModalInstance, $state, $rootScope, Auth, User){
  var vm = this;
  vm.cancel = function() {
    $uibModalInstance.dismiss('cancel');
  };

  vm.login = function() {
    vm.loginFailed = false;
    Auth.login(vm.user).then(function(response){
      $rootScope.stateChangeInProgress = true;
      var value = response;
      $rootScope.userInfo = value;
      localStorage.setItem("userInfo", JSON.stringify(response));
      User.get(response.id).then(function(response){
        var value = response.data;
        $rootScope.userSetting = value.user_setting;
        $state.go('home');
        $uibModalInstance.dismiss('cancel');
      }).catch(function (err) {}).finally(function(){
         $rootScope.stateChangeInProgress = false; });
    }, function(){
      vm.loginFailed = true;
      delete $rootScope.userInfo;
      localStorage.setItem("userInfo", undefined)
    });
  };
};

SignInModalInstanceCtrl.$inject = ['$uibModalInstance', '$state', '$rootScope', 'Auth', 'User'];

var signInModal = function($uibModal){
  return {
    link: function(scope, element){
      element[0].addEventListener('click', function(){
        $uibModal.open({
          controller: SignInModalInstanceCtrl,
          templateUrl: templateUrl,
          controllerAs: 'vm',
          windowClass: 'center-modal'
        });
      });
    }
  };
};

signInModal.$inject = ['$uibModal'];

export default signInModal;
