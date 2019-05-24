var indexTemplateUrl = require('./index/index.html');
import QuestionsCtrl from './index/questions-ctrl';

var routing = function($stateProvider){
  $stateProvider.state('questions', {
    url: '/questions?within_search_radius',
    templateUrl: indexTemplateUrl,
    controller: QuestionsCtrl,
    controllerAs: 'vm',
    title: 'Wellmet - Questions',
    data: {
            title: 'Ask Question Online|Find friends Near By|Live Chat',
            description: 'Ask any question to your friends and get a solution on time. With Wellmet you can identify your best mates with the same interest by clicking on interest icon. '
        },
    resolve: {
      questions: ['Question', '$stateParams', function(Question, $stateParams){
        return Question.query($stateParams);
      }],
      answers: ['questions', 'Answer', function(questions, Answer){
        var question_ids = questions.data.map(function(q){
          return q.id;
        });
        return Answer.query({question_id_in: question_ids});
      }],
      users: ['answers', 'User', function(answers, User){
        var user_ids = answers.data.map(function(a){
          return a.user_id;
        });
        return User.query({id_in: user_ids});
      }],
      user: ['$rootScope', 'User', function($rootScope, User){
        return User.get($rootScope.userInfo && $rootScope.userInfo.id);
      }]
    }
  });
};

routing.$inject = ['$stateProvider'];

export default routing;
