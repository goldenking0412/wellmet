var successModalTemplateUrl = require('./success-modal.html');

var PasswordResetCtrl = function($scope, $state, $rootScope, $uibModal, Auth){
  var vm = this;
  vm.resetPassword = function(){
    vm.error = undefined;
    $rootScope.stateChangeInProgress = true;
    Auth.sendResetPasswordInstructions({email: vm.email}).then(
      function(){
        $uibModal.open({
          scope: $scope,
          templateUrl: successModalTemplateUrl,
          windowClass: 'center-modal',
          backdropClass: 'no-click'
        });
        $rootScope.stateChangeInProgress = false;
      },
      function(response){
        vm.error = response.data.errors.email[0];
        $rootScope.stateChangeInProgress = false;
      }
    );
  };


};

PasswordResetCtrl.$inject = ['$scope', '$state', '$rootScope', '$uibModal', 'Auth'];

export default PasswordResetCtrl;
