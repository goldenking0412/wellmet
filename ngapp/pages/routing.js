import PageCtrl from './show/page-ctrl';
var showTemplateUrl = require('./show/show.html');

var routing = function($stateProvider) {
  $stateProvider
    .state('page', {
      url: '/:slug',
      templateUrl: showTemplateUrl,
      controller: PageCtrl,
      controllerAs: 'vm',
      title: 'Wellmet - Page',
      resolve: {
        page: ['Page', '$stateParams', function(Page, $stateParams){
          console.log("-- coming in --");
          console.log(Page.get($stateParams.slug, $stateParams));
          return Page.get($stateParams.slug, $stateParams);
        }],
      },
    });
};

routing.$inject = ['$stateProvider'];

export default routing;
