var successModalTemplateUrl = require('./success-modal.html');
var PasswordEditCtrl = function(Auth, $state, $rootScope, $uibModal){
  var vm = this;
  vm.resetPassword = function(){
    vm.error = undefined;
    $rootScope.stateChangeInProgress = true;
    Auth.resetPassword({
      password: vm.password,
      password_confirmation: vm.password,
      reset_password_token: $state.params.reset_password_token
    }).then(
      function(){
        $uibModal.open({
          templateUrl: successModalTemplateUrl,
          windowClass: 'center-modal',
          backdropClass: 'no-click'
        });
      },
      function(response){
        vm.error = response.data.errors.password[0];
        $rootScope.stateChangeInProgress = false;
      }
    );
  };
};

PasswordEditCtrl.$inject = ['Auth', '$state', '$rootScope', '$uibModal'];

export default PasswordEditCtrl;
