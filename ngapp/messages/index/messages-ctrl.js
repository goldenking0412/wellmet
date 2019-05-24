var deleteMessagesConfirmDialogTemplate = require('./delete-messages-confirm-dialog.html');
var shareInterestModal = require('./share-interest-modal.html');
var shareSuccessModalTemplate = require('./share-success-modal.html');
var blockConfirmModalTemplate = require('./block-user-confirm-modal.html');
var MessagesCtrl = function($scope, $interval, $state, $stateParams, $rootScope, $timeout, $uibModal,
  User, Message, Hail, UserBlock, user, toUser, interests, hails, Interest, UserInterestShare){
  var ACTIVE_TIMEOUT_THRESHHOLD = 1*60*1000;
  var INTERESTS_TIMEOUT = 1*60*1000;
  var CHAT_TIMEOUT = 3000;

  var vm = this;

  vm.user = user.data;
  vm.toUser = toUser.data;
  vm.messages = [];
  vm.interests = interests.data;
  vm.hail = hails.data && hails.data[0];
  $scope.today = new Date();

  vm.loadDate = function(){
    $scope.messageDate = new Date();
    console.log($scope.messageDate.getHours(), "ll11111l");
    if ($scope.messageDate.getHours() < 24) {
      console.log($scope.messageDate.getHours(), "lll");
      $scope.displayDate = "Today"
      return $scope.messageDate;
    }
  };

  var convertMS = function(ms) {
    var d, h, m, s;
    s = Math.floor(ms / 1000);
    m = Math.floor(s / 60);
    s = s % 60;
    h = Math.floor(m / 60);
    m = m % 60;
    d = Math.floor(h / 24);
    h = h % 24;
    return { d: d, h: h, m: m, s: s };
  };

  vm.onlineHours = function(user){
    var today = new Date();
    var crnt = new Date(user.current_sign_in_at);
    $scope.online_hrs = today.getTime() - crnt.getTime();
    $scope.online_hr = convertMS($scope.online_hrs);
    return $scope.online_hr;
  };

  vm.offlineHours = function(user){
    var crnt = new Date(user.last_logged_out_at);
    $scope.offline_hr = crnt.getTime();
    return $scope.offline_hr;
  };

  vm.lastMessage = function(user) {
    $rootScope.messages = user.messages;
    $scope.messageList = [];
    angular.forEach($rootScope.messages, function(msg) {
      if (msg.to_user_id === vm.user.id) $scope.messageList.push(msg);
    });
    var res = Math.max.apply(Math,$scope.messageList.map(function(obj){return obj.id;}))
    var recent_message = $scope.messageList.find(function(obj){ return obj.id == res; })
    return recent_message;
  };

  vm.dateList = [];
  vm.dateDisplay = function(message_date_time, count) {
    $scope.today = new Date();
    $scope.yesterday = new Date().setDate($scope.today.getDate() -1);
    var message_updated = new Date(message_date_time);
    var message_updated_date = message_updated.getDate();
    var message_updated_mnth = message_updated.getMonth();
    var message_updated_year = message_updated.getFullYear();
    var message_updated_at = parseInt(message_updated_date +""+ message_updated_mnth +""+ message_updated_year);
    var today_date = parseInt($scope.today.getDate() +""+ $scope.today.getMonth() +""+ $scope.today.getFullYear());
    if (message_updated_at === today_date) {
      var day = "today";
    }
    else if (message_updated_at === today_date) {

    }
    var exists = vm.dateList.some(function (o) {
        return message_updated_at === o;
    });
    vm.dateList.push(message_updated_at);
    if (vm.dateList.length == count) {
      vm.dateList = [];
    }
    if (exists == false) {
      return message_date_time;
    }
  };

  vm.unreadMessageCount = function(mess) {
    $scope.messageCount = [];
    angular.forEach(mess, function(msg) {
      if ((msg.to_user_id === vm.user.id) && (msg.read == false)) $scope.messageCount.push(msg);
    });
    return $scope.messageCount.length;
  };

  var scrollToLastMessage = function(){
    $timeout(function(){
      var target = document.querySelector('.chat-message:last-child');
      target.parentNode.scrollTop = target.offsetTop;
    });
  };

  var loadMessages = function(){
    if($stateParams.to_user_id_eq){
      var messagesCount = vm.messages.length;
      Message.query(angular.extend({poll: true}, $stateParams)).then(function(response){
        var value = response.data;
        vm.messages = value;
        if(vm.messages.length > messagesCount){
          scrollToLastMessage();
        }
      }).catch(function(error){
        if(error.error == "blocked"){
          alert("Blocked")
          window.location = "/#/messages";
        } else if(error.error == "no_hails"){
          window.location = "/#/messages";
        }
      });
    }
  };

  var loadUsers = function(){
    var params = {id_not_eq: $rootScope.userInfo && $rootScope.userInfo.id, chattable: true};

    if($stateParams.tab == 'online'){
      params.online = true;
    } else if($stateParams.tab == 'offline'){
      params.online = false;
    } else if($stateParams.tab == 'hails'){
      params.hailed = true;
      delete params.chattable;
    }
    User.query(params).then(function(response){
      var value = response.data;
      vm.users = value;
    }).catch(function (err) {});
  };

  var loadInterests = function(){
    Interest.query({common_to_user_id: $stateParams.to_user_id_eq}).then(function(response) {
      var value = response.data;
      vm.interests = value;
    }).catch(function (err) {});
  };

  vm.sendMessage = function(){
    vm.sendingMessage = true;
    Message.save({message: {text: vm.messageText, to_user_id: vm.toUser.id}}).then(function(response){
      var value = response.data;
      vm.messages.push(value);
      $timeout(function(){
        scrollToLastMessage();
      });
    }).catch(function(error){
      if(error.error == "blocked"){
        alert("Blocked")
        window.location = "/#/messages"
      }
    }).finally(function(){
      vm.messageText = '';
      vm.sendingMessage = false;
    });
  };

  vm.hailAction = function(accepted){
    vm.updatingHail = true;
    if(accepted){
      Hail.update(vm.hail.id, {hail: {accepted: accepted}}).then(function(response){
        var value = response.data;
        if(vm.users.length == 1){
          $state.go('messages', {to_user_id_eq: value.user_id, tab: 'all'});
        }
      }).catch(function (err) {}).finally(function(){
        vm.updatingHail = false;
      });
    } else {
      Hail.destroy(vm.hail.id).then(function(response){
        $state.go('messages', {tab: 'hails'});
      }).catch(function (err) {}).finally(function(){
        vm.updatingHail = false;
      });
    }
  };

  vm.deleteMessages = function(){
    Message.deleteAll({to_user_id_eq: vm.userToDelete.id}).then(function(){
      $state.go('messages', {tab: 'edit'}, {reload: true});
    }).catch(function (err) {});
  };

  vm.blockUser = function(){
    UserBlock.save({user_block: { blocked_user_id: vm.toUser.id }}).then(function(){
      $state.go('messages', {tab: 'all', to_user_id_eq: null}, {reload: true});
    }).catch(function (err) {});
  }

  vm.openDeleteMessagesModal = function(){
    $uibModal.open({
      templateUrl: deleteMessagesConfirmDialogTemplate,
      windowClass: 'center-modal',
      scope: $scope
    });
  };

  vm.openBlockUserModal = function(){
    $uibModal.open({
      templateUrl: blockConfirmModalTemplate,
      windowClass: 'center-modal',
      scope: $scope
    })
  }

  vm.openShareInterestsModal = function() {
    Interest.query({unlocked_to_user_id: $stateParams.to_user_id_eq }).then(function(interests){
      vm.allInterests = interests.data
      UserInterestShare.query({ user_id: $rootScope.userInfo && $rootScope.userInfo.id, to_user_id: $stateParams.to_user_id_eq }).then(function(userInterestShares){
        vm.userInterestShares = userInterestShares.data
        vm.sharedInterests = {}
        vm.userInterestShares.forEach(function(uis){
          vm.sharedInterests[uis.interest_id] = true
        })
        $uibModal.open({
          templateUrl: shareInterestModal,
          windowClass: 'center-modal',
          scope: $scope
        });
      });
    }).catch(function (err) {});

    vm.shareInterest = function() {
      for(var interest_id in vm.sharedInterests){

        var userInterestShare = vm.userInterestShares.filter(function(uis){ return uis.interest_id == interest_id; })[0];
        if(vm.sharedInterests[interest_id] == true){
          if(!userInterestShare){
            UserInterestShare.save({ interest_id: interest_id, to_user_id: $stateParams.to_user_id_eq })
          }
        } else if(vm.sharedInterests[interest_id] == false) {

          if(userInterestShare){
            UserInterestShare.destroy(userInterestShare.id)
          }
        }
      }
      shareSuccessModal();
    }
  };

  var shareSuccessModal = function(){
    $uibModal.open({
      templateUrl: shareSuccessModalTemplate,
      windowClass: 'center-modal',
      scope: $scope
    })
  }

  var usersTimer = $interval(loadUsers, ACTIVE_TIMEOUT_THRESHHOLD);

  var interestsTimer = $interval(loadInterests, ACTIVE_TIMEOUT_THRESHHOLD);

  var messagesTimer = $interval(loadMessages, CHAT_TIMEOUT);

  $scope.$on('$destroy', function(){
    $interval.cancel(usersTimer);
    $interval.cancel(messagesTimer);
    $interval.cancel(interestsTimer);
  });

  loadMessages();
  loadUsers();
  loadInterests();
};

MessagesCtrl.$inject = ['$scope', '$interval', '$state', '$stateParams', '$rootScope', '$timeout', '$uibModal',
  'User', 'Message', 'Hail', 'UserBlock', 'user', 'toUser', 'interests', 'hails', 'Interest', 'UserInterestShare'];

export default MessagesCtrl;
