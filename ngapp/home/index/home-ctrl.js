var HomeCtrl = function($state, $rootScope, $sce, Auth, User, interests) {
  this.interests = interests.data;
  var vm = this;
  vm.cancel = function() {
    $uibModalInstance.dismiss('cancel');
  };

  $rootScope.trustAsHtml = function(string) {
    return $sce.trustAsHtml(string);
  };

  if($state.params.name_cont){
    vm.name_content = $state.params.name_cont;
  }

  vm.login = function() {
    console.log("coming in");
    vm.loginFailed = false;
    Auth.login(vm.user).then(function(response){
      $rootScope.stateChangeInProgress = true;
      var value = response;
      $rootScope.userInfo = value;
      localStorage.setItem("userInfo", JSON.stringify(response));
      User.get(response.id).then(function(response){
        var value = response.data;
        $rootScope.userSetting = value.user_setting;
        $rootScope.stateChangeInProgress = false;
        $state.go('home');
      }).catch(function (err) {});
    }, function(){
      vm.loginFailed = true;
      delete $rootScope.userInfo;
      localStorage.setItem("userInfo", undefined)
    });
  };
};

HomeCtrl.$inject = ['$state', '$rootScope','$sce', 'Auth', 'User', 'interests'];

export default HomeCtrl;
