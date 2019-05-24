var saveSuccessModalTemplate = require('./save-success-modal.html');
var locationRefusedModalTemplate = require('./location-refused-modal.html');
var locationResponseModalTemplate = require('./location-response-modal.html');

var UserEditCtrl = function($rootScope, $uibModal, $state, $http, $geolocation, Auth, Months, Years, User, user, Ages, UserSetting, blockedUsers, userBlocks, UserBlock, UserInterest){
  var vm = this;
  vm.activeStep = 2;
  vm.user = user.data;
  vm.Months = Months;
  vm.Years = Years;
  vm.ages = Ages;
  vm.settingsstep = 1;
  vm.userSetting = vm.user.user_setting;
  vm.blockedUsers = blockedUsers.data;
  vm.notificationSettings = {
    sound_notification: 'Sound Notification',
    question_notification: 'Question Notification',
    hail_notification: 'Hail Notification',
    chat_notification: 'Chat Notification',
  };

  if(vm.userSetting && vm.userSetting.gender == '')
  {
    vm.userSetting.gender = "both"
  }

  if($state.params.interest_id && $state.params.comment && $state.params.like){
     $rootScope.interestid = $state.params.interest_id
     $rootScope.commentdata = $state.params.comment
     $rootScope.like = $state.params.like
  }

  vm.heading = ["General","Security","Privacy","Block List","Notifications","Support","Find settings","Delete Account"];

  var api_key = 'AIzaSyBxPXhX7mtb3M6eQxWc9qBqPcZj_YLqnY0';
  $rootScope.isCollapsed = true;
  vm.update_current_location = function(vm) {
    if($rootScope.co_ordinates) {
      var coordinate_value = $rootScope.co_ordinates;
    }
    else {
      var coordinate_value = $rootScope.lol;
    }
    if($rootScope.lol || $rootScope.co_ordinates) {
      var coords = coordinate_value.latitude +"," + coordinate_value.longitude;
      var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + coords + "&key=" + api_key;
      console.log(url, "===url===");
      $http.get(url, {headers : {'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'}}).then( function(response) {
        console.log(response.data.results[0].formatted_address, "----response----");
        vm.user.location = response.data.results[0].formatted_address;
      }).catch(function(err){
        console.log(err, "--err---");
        $uibModal.open({
        templateUrl: locationResponseModalTemplate,
        windowClass: 'center-modal',
      })
      });
    }
    else{
      console.log("no geolocation");
      $uibModal.open({
        templateUrl: locationRefusedModalTemplate,
        windowClass: 'center-modal',
      })
    }
  }

  if($rootScope.co_ordinates) {
    var coordinate_value = $rootScope.co_ordinates;
  }
  else {
    var coordinate_value = $rootScope.lol;
  }
  if($rootScope.lol || $rootScope.co_ordinates) {
    var coords = coordinate_value.latitude +"," + coordinate_value.longitude;
    var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + coords + "&key=" + api_key;
    console.log(url, "===url===");
    $http.get(url, {headers : {'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'}}).then( function(response) {
      console.log(response.data.results[0].formatted_address, "----response----");
      if(!$state.params.current_step) {
        vm.user.location = response.data.results[0].formatted_address;
      }
    }).catch(function(err){
      console.log(err, "--err---");
    //   $uibModal.open({
    //   templateUrl: locationResponseModalTemplate,
    //   windowClass: 'center-modal',
    // })
    });
  }
  else{
    console.log("--- no geolocation fetched ---");
    // alert("Browser refused to fetch Geolocation due to some reason");
  }

  vm.updateUser = function(vm){
    user = vm.user
    console.log(user,"usersssss");
    $rootScope.stateChangeInProgress = true;
    vm.errors = [];
    User.update(user.id, {user: user}).then(function(){
      if(vm.user.password){
        Auth.login({password: user.password, username: vm.user.username})
      }
      delete user.password
      delete user.password_confirmation
      delete user.current_password

      $uibModal.open({
        templateUrl: saveSuccessModalTemplate,
        windowClass: 'center-modal',
      })

    }).catch(function(response){
      var value = response.data;
      vm.errors = value.errors;
      vm.user.password = "";
      vm.user.password_confirmation = "";
      vm.user.current_password = "";
    }).finally(function(){
      $rootScope.stateChangeInProgress = false;
    });
  };

  var saveUserInterest = function(){
    UserInterest.save({user_interest: {user_id: vm.user.id, interest_id: $rootScope.interestid, comment: $rootScope.commentdata, like: $rootScope.like}}).then(function(response){
      var value = response.data;
      vm.activeStep = 3;
    }).catch(function(response){
       var value = response.data;
       vm.errors = value.errors;
     });
  };

  vm.editUser = function(vm){
    var dateofbirth =  document.getElementById('datevalue').value;
    vm.user.date_of_birth = dateofbirth
    user = vm.user
    $rootScope.stateChangeInProgress = true
    vm.errors = [];
    User.update(user.id, {user: user}).then(function(){
      if(vm.user.password){
        Auth.login({password: user.password, username: vm.user.username})
      }
      delete user.password
      delete user.password_confirmation
      delete user.current_password
      $rootScope.Auth._currentUser = vm.user
      saveUserInterest();
    }).catch(function(response){
      var value = response.data;
      vm.errors = value.errors;
    }).finally(function(){
      $rootScope.stateChangeInProgress = false;
    });

  };

  vm.togglecollapse = function(){
    $rootScope.isCollapsed = !$rootScope.isCollapsed
  };

  vm.saveUserSetting = function(userSetting){
    $rootScope.stateChangeInProgress = true;
    vm.errors = [];
    UserSetting.save({user_setting: userSetting}).then(function(userSetting){
      $rootScope.userInfo.user_setting = userSetting.data;
      $rootScope.userSetting = userSetting.data;
      $uibModal.open({
        templateUrl: saveSuccessModalTemplate,
        windowClass: 'center-modal',
      })
    }).catch(function(response){
      var value = response.data;
      vm.errors = value.errors;
      vm.errors = response.errors;
    }).catch(function (err) {}).finally(function(){
      $rootScope.stateChangeInProgress = false;
    });
  };

  vm.saveLocalSetting = function(userSetting){
    if(userSetting.ages["19a"] == true)
    {
      userSetting.ages["19u"] = false;
    }
    if(userSetting.gender == "both")
    {
      userSetting.gender = ""
    }
    $rootScope.stateChangeInProgress = true;
    vm.errors = [];
    UserSetting.save({user_setting: userSetting}).then(function(userSetting){
      $rootScope.userInfo.user_setting = userSetting.data;
      $rootScope.userSetting = userSetting.data;
      $uibModal.open({
        templateUrl: saveSuccessModalTemplate,
        windowClass: 'center-modal',
      })
    }).catch(function(response){
      var value = response.data;
      vm.errors = value.errors;
      vm.errors = response.errors;
    }).catch(function (err) {}).finally(function(){
      $rootScope.stateChangeInProgress = false;
      $state.go('users');
    });
  };

  vm.blockUser = function(){
    UserBlock.save({user_block: {username: vm.usernameToBlock}}).then(function(){
      $state.reload();
    }).catch(function(err){
      console.log(err.data.blocked_user_id[0],"errrrrr");
      var error = err.data.blocked_user_id[0].substring(0,1).toUpperCase() + err.data.blocked_user_id[0].substring(1);
      vm.errors = [error];
    });
  };

  vm.completed = function(){
    $state.go('home');
  };

  vm.unblockUser = function(user){
    $rootScope.stateChangeInProgress = true;
    var id = userBlocks.data.filter(function(u){ return u.blocked_user_id == user.id })[0].id
    UserBlock.destroy(id).then(function(){
      vm.blockedUsers.splice(vm.blockedUsers.indexOf(user), 1);
    }).catch(function (err) {}).finally(function(){
      $rootScope.stateChangeInProgress = false;
    });
  };

  vm.deleteUser = function(){
    User.destroy($rootScope.userInfo.id).then(function(){
      window.location = '/'
    }).catch(function (err) {});
  };

};

export default UserEditCtrl;
