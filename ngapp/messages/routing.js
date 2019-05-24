var indexTemplateUrl = require('./index/index.html');
import MessagesCtrl from './index/messages-ctrl';

var routing = function($stateProvider){
  $stateProvider.state('messages', {
    url: '/messages?to_user_id_eq&tab, ',
    templateUrl: indexTemplateUrl,
    controller: MessagesCtrl,
    controllerAs: 'vm',
    data: {
            title: 'Live free Online Chat|Share your interests|Online Friends',
            description: 'Wellmet- Be interesting. Share your thoughts online with the free online chatting tool. Find more friends of the same interest near by and meet people online.',
        },
    title: 'Wellmet - Chat',
    resolve: {
      user: ['$rootScope', 'User', function($rootScope, User){
        return User.get($rootScope.userInfo && $rootScope.userInfo.id);
      }],
      toUser: ['User', '$stateParams', function(User, $stateParams){
        if($stateParams.to_user_id_eq){
          return User.get($stateParams.to_user_id_eq);
        } else {
          return {};
        }
      }],
      interests: ['$stateParams', 'Interest', function($stateParams, Interest){
        if($stateParams.to_user_id_eq){
          return Interest.query({common_to_user_id: $stateParams.to_user_id_eq});
        } else {
          return [];
        }
      }],
      hails: ['Hail', '$stateParams', function(Hail, $stateParams){
        return Hail.query({user_id_eq: $stateParams.to_user_id_eq});
      }]
    }
  });
};

routing.$inject = ['$stateProvider'];

export default routing;
