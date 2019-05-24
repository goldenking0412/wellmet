import InterestCtrl from './show/interest-ctrl';
var showTemplateUrl = require('./show/show.html');

var routing = function($stateProvider) {
  $stateProvider
    .state('interest', {
      url: '/interests/:id',
      templateUrl: showTemplateUrl,
      controller: InterestCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Interest',
      resolve: {
        interest: ['Interest', '$stateParams', function(Interest, $stateParams){
          return Interest.get($stateParams.id, $stateParams);
        }],

        userInterests: ['UserInterest', '$stateParams', function(UserInterest, $stateParams){
          return UserInterest.query({interest_id_eq: $stateParams.id, limit: 10});
        }],

        users: ['User', 'userInterests', function(User, userInterests){
          var userIds = userInterests.data.map(function(u){
            return u.user_id;
          });

          return User.query({id_in: userIds});
        }]
      },
    });
};

routing.$inject = ['$stateProvider'];

export default routing;
