import AnswerNewCtrl from './new/answer-new-ctrl';
var newTemplateUrl = require('./new/new.html');

var routing = function($stateProvider) {
  $stateProvider.state('answer-new', {
    url: '/answers/new?radius',
    templateUrl: newTemplateUrl,
    controller: AnswerNewCtrl,
    controllerAs: 'vm',
    title: 'Wellmet - Answer',
    data: {
            title: 'Find Right Answers| Find friends Near By|Live Chat',
            description: 'Find right answers online easily. Post questions online and get suggestions from the real friends online. Make new friends with Wellmet - the interesting.'
        },
    resolve: {
      questions: ['Question', '$rootScope', '$stateParams', function(Question, $rootScope, $stateParams) {
        return Question.query({random: true, limit: 5, user_id_not_eq: $rootScope.userInfo && $rootScope.userInfo.id, radius: $stateParams.radius});
      }]
    }
  });
};

routing.$inject = ['$stateProvider'];

export default routing;
