import HomeCtrl from './index/home-ctrl';

var indexTemplateUrl = require('./index/index.html');

var routing = function($stateProvider, $urlRouterProvider, $locationProvider) {
  // $locationProvider.html5Mode({
  //   enabled: true,
  //   requireBase: false
  // });

  $urlRouterProvider.otherwise('/');

  $stateProvider
    .state('home', {
      url: '/?added_date_range&name_cont&category_id_eq',
      templateUrl: indexTemplateUrl,
      controller: HomeCtrl,
      controllerAs: 'vm',
      data: {
            title: 'Meet the Most Interesting People | Make New Friends | Fun Life ',
            description: 'Looking for new friends? Make friends of the same interest with the free online chatting site. Meet the common interest people near you and share your thoughts.'
        },
      title: 'Meet the Most Interesting People | Make New Friends | Be Interesting',
      resolve: {
        interests: ['Interest', '$stateParams', function(Interest, $stateParams){
          var params = angular.copy($stateParams);
          if(!params.added_date_range){
            params.added_date_range = 'lifetime';
          }

          params.limit = 10

          return Interest.query(params);
        }]
      },
    });
};

routing.$inject = ['$stateProvider', '$urlRouterProvider','$locationProvider'];

export default routing;
