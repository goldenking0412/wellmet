var deleteInterestConfirmModalTemplate = require('./delete-interest-confirm-modal.html');
var UserCtrl = function($scope, $state, $http, Upload, $timeout, $uibModal, User, UserInterest, user, userInterests, interests, currentUserInterests, userInterestShares) {
  var vm = this;
  vm.userInterests = userInterests.data;
  vm.user = user.data;
  vm.interests = interests.data;
  vm.User = User;
  $scope.dataUrl = $state.params.image_url;
  $scope.name = $state.params.image_name;
  if($scope.dataUrl && $scope.name) {
    console.log("enter");
    console.log(Upload.dataUrltoBlob($state.params.image_url, $state.params.image_name), "blob_url");
    console.log(User.get(2), "user_info");
    Upload.upload({
      url: 'https://angular-file-upload-cors-srv.appspot.com/upload',
      data: {
          file: Upload.dataUrltoBlob($scope.dataUrl, $scope.name)
      },
    }).then(function (response) {
      $timeout(function () {
        $scope.result = response.data;
        vm.user.profilephoto = $state.params.image_url;
        User.update(vm.user.id, {profilephoto: vm.user.profilephoto}).then(function(response){
        }).catch(function (err) {});
        console.log($scope.result.result[0].name, "pic_name");
      });
    }, function (response) {
        if (response.status > 0) $scope.errorMsg = response.status + ': ' + response.data;
    }, function (evt) {
        $scope.progress = parseInt(100.0 * evt.loaded / evt.total);
    });
  };

  vm.openDeleteInterestConfirmModal = function(){
    $uibModal.open({
      templateUrl: deleteInterestConfirmModalTemplate,
      windowClass: 'center-modal',
      scope: $scope
    });
  };

  vm.removeUserInterest = function(){
    UserInterest.destroy(vm.userinterest.id).then(function(){
      $state.go($state.current, {}, {reload: true});
    }).catch(function (err) {});
  };

  vm.isOpen = function(userInterest) {
    var uisCount = userInterestShares.data.filter(function(uis) { return uis.interest_id == userInterest.interest_id; }).length;
    var cuiCount = currentUserInterests.data.filter(function(cui) { return cui.interest_id == userInterest.interest_id && cui.like == userInterest.like; }).length;

    return cuiCount || uisCount
  }
};

UserCtrl.$inject = ['$scope','$state', '$http', 'Upload', '$timeout', '$uibModal','User', 'UserInterest', 'user', 'userInterests', 'interests', 'currentUserInterests', 'userInterestShares'];

export default UserCtrl;
