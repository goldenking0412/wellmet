var showTemplateUrl = require('./show/show.html');
var newTemplateUrl = require('./new/new.html');
var editTemplateUrl = require('./edit/edit.html');
var editGeneralTemplateUrl = require('./edit/_general.html');
var editSecurityTemplateUrl = require('./edit/_security.html');
var editLocateSettingsTemplateUrl = require('./edit/_locate_settings.html');
var editPrivacyTemplateUrl = require('./edit/_privacy.html');
var editBlockListsTemplateUrl = require('./edit/_block_list.html');
var editNotificationsTemplateUrl = require('./edit/_notifications.html');
var editSupportTemplateUrl = require('./edit/_support.html');
var editDeleteAccountTemplateUrl = require('./edit/_delete_account.html');
var indexTemplateUrl = require('./index/index.html');
var passwordResetTemplateUrl = require('./password-reset/password-reset.html');
var passwordEditTemplateUrl = require('./password-edit/password-edit.html');
var updateTemplateUrl = require('./edit/user_update.html');
import UserCtrl from './show/user-ctrl';
import UserNewCtrl from './new/user-new-ctrl';
import UserEditCtrl from './edit/user-edit-ctrl';
import UsersCtrl from './index/users-ctrl';
import PasswordResetCtrl from './password-reset/password-reset-ctrl';
import PasswordEditCtrl from './password-edit/password-edit-ctrl';

var routing = function($stateProvider, $locationProvider) {

  // $locationProvider.html5Mode({
  //   enabled: true,
  //   requireBase: false
  // });

  $stateProvider
    .state('users', {
      url: '/users?category_id?radius_id',
      templateUrl: indexTemplateUrl,
      controller: UsersCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Locate',
      resolve: {
        interests: ['$stateParams', '$rootScope', 'Interest', function($stateParams, $rootScope, Interest){
          return Interest.query({users_id_eq: $rootScope.userInfo && $rootScope.userInfo.id});
        }],
        user: ['$rootScope', 'User', function($rootScope, User){
          if($rootScope.userInfo){
            return User.get($rootScope.userInfo.id);
          } else {
            return {};
          }
        }]
      }
    })
    .state('user-new', {
      url: '/users/new',
      templateUrl: newTemplateUrl,
      controller: UserNewCtrl,
      controllerAs: 'vm',
      title: 'Wellment - Sign up',
      resolve: {
        notAuthorized: ['Auth', function(Auth){
          return !Auth.isAuthenticated();
        }]
      }
    }).state('users-password-reset', {
      url: '/users/password_reset',
      templateUrl: passwordResetTemplateUrl,
      controller: PasswordResetCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Password Reset'
    }).state('users-password-edit', {
      url: '/users/password/edit?reset_password_token',
      templateUrl: passwordEditTemplateUrl,
      controller: PasswordEditCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Change Password'
    }).state('user', {
      url: '/users/:id?image_url?image_name',
      templateUrl: showTemplateUrl,
      controller: UserCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Profile',
      resolve: {
        user: ['$stateParams', 'User', function($stateParams, User) {
          return User.get($stateParams.id);
        }],

        userInterests: ['UserInterest', '$stateParams', function(UserInterest, $stateParams){
          return UserInterest.query({ user_id_eq: $stateParams.id });
        }],

        interests: ['Interest', 'userInterests', function(Interest, userInterests){
          var interestIds = userInterests.data.map(function(u){
            return u.interest_id;
          });
          return Interest.query({id_in: interestIds});
        }],
        userInterestShares: ['UserInterestShare', 'user', '$rootScope', function(UserInterestShare, user, $rootScope) {
          return UserInterestShare.query({ user_id:  user.data.id, to_user_id: $rootScope.userInfo && $rootScope.userInfo.id})
        }],
        currentUserInterests: ['UserInterest', '$rootScope', function(UserInterest, $rootScope){
          return UserInterest.query({ user_id_eq: $rootScope.userInfo && $rootScope.userInfo.id });
        }],
      },
    }).state('user-edit', {
      url: '/users/:id/edit?current_step',
      templateUrl: editTemplateUrl,
      controller: UserEditCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Settings',
      resolve: {
        user: ['$stateParams', 'User', function($stateParams, User) {
          return User.get($stateParams.id);
        }],
        userBlocks: ['UserBlock', function(UserBlock){
          return UserBlock.query();
        }],
        blockedUsers: ['userBlocks', 'User', function(userBlocks, User){
          var blockedUserIds = userBlocks.data.map(function(u){ return u.blocked_user_id; });
          if(blockedUserIds.length > 0){
            return User.query({id_in: blockedUserIds});
          } else {
            return {}
          }
        }]
      }
    }).state('user-update', {
      url: '/users/:id/social_update?interest_id?comment?like',
      templateUrl: updateTemplateUrl,
      controller: UserEditCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Settings',
      resolve: {
        user: ['$stateParams', 'User', function($stateParams, User) {
          return User.get($stateParams.id);
        }],
        userBlocks: ['UserBlock', function(UserBlock){
          return UserBlock.query();
        }],
        blockedUsers: ['userBlocks', 'User', function(userBlocks, User){
          var blockedUserIds = userBlocks.data.map(function(u){ return u.blocked_user_id; });
          if(blockedUserIds.length > 0){
            return User.query({id_in: blockedUserIds});
          } else {
            return {}
          }
        }]
      }
    });
};

routing.$inject = ['$stateProvider', '$locationProvider'];

export default routing;
