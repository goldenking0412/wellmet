var newTemplateUrl = require('./new/new.html');
import UserInterestNewCtrl from './new/user-interest-new-ctrl';

var routing = function($stateProvider) {
  $stateProvider
    .state('user-interest-new', {
      url: '/users_interests/new?category_id&interest_id',
      templateUrl: newTemplateUrl,
      controller: UserInterestNewCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Add Interest',
      resolve: {
        interest: ['$stateParams', 'Interest', function($stateParams, Interest){
          if($stateParams.interest_id){
            return Interest.get($stateParams.interest_id)
          } else {
            return null
          }
        }],
        user: ['User', '$rootScope', function(User, $rootScope){
          return User.get($rootScope.userInfo && $rootScope.userInfo.id)
        }]
      }
    });
};

routing.$inject = ['$stateProvider'];

export default routing;
