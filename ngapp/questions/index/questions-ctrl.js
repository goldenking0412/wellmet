var hailSuccessModalTemplate = require('./hail-success-modal.html');
var deleteQuestionConfirmModalTemplate = require('./delete-question-confirm-modal.html');
var deleteAnswerConfirmModalTemplate = require('./delete-answer-confirm-modal.html');

var QuestionsCtrl = function($scope, $rootScope, $state, $uibModal, $window, Hail, User, Question, Answer, questions, answers, users, user){
  var vm = this;

  vm.answers = answers.data;
  vm.users = users.data;
  vm.questions = questions.data;
  vm.user = user.data;
  $scope.isCollapsed =  false;

  vm.appreciate = function(answer,user){
    Answer.update(answer.id, {appreciated: true}).then(function(response){
      answer.appreciated = true;
      var value = user.points;
      var value = value + 1;
      user.points = value;
    }).catch(function (err) {
      var value = err.data;
    }).finally(function(){
    });;
  };

  vm.saveQuestion = function(response) {
    $rootScope.stateChangeInProgress = true;
    vm.errors = [];

    Question.save(vm.question).then(function(response){
      var value = response.data;
      vm.questions.unshift(value);
      vm.question.text = "";
    }).catch(function(response){
      var value = response.data;
      vm.errors = value.errors;
    }).finally(function(){
      $rootScope.stateChangeInProgress = false;
    });
  };

  vm.hail = function(user, hailMessage){
    user.hailingInProgress = true;
    Hail.save({hail: {to_user_id: user.id, message: hailMessage}}).then(function(){
      user.hailing = false;
      user.hailed = true;
      $uibModal.open({
        scope: $scope,
        templateUrl: hailSuccessModalTemplate,
        windowClass: 'center-modal',
        backdropClass: 'no-click'
      });
    }).catch(function (err) {
      var value = err.data;
    }).finally(function(){
      user.hailingInProgress = false
    });
  }

  vm.isCollapsed = function(questionid){
    console.log("collapsewss function called");
    vm.collapsed = questionid;
    $scope.isCollapsed =  !$scope.isCollapsed;
    console.log("collapsesss function called");
  }

  vm.openDeleteQuestionConfirmModal = function(){
    $uibModal.open({
      templateUrl: deleteQuestionConfirmModalTemplate,
      windowClass: 'center-modal',
      scope: $scope
    });
  };

  vm.deleteQuestion = function(){
    Question.delete(vm.questionToDelete.id).then(function(){
      $state.go('questions', {}, {reload: true});
    }).catch(function (err) {});
  };

  vm.openDeleteAnswerConfirmModal = function(){
    $uibModal.open({
      templateUrl: deleteAnswerConfirmModalTemplate,
      windowClass: 'center-modal',
      scope: $scope
    });
  };

  vm.deleteAnswer = function(){
    Answer.delete(vm.answerToDelete.id).then(function(){
      $state.go('questions', {}, {reload: true});
    }).catch(function (err) {});
  };

};

QuestionsCtrl.$inject = ['$scope', '$rootScope', '$state', '$uibModal', '$window', 'Hail', 'User', 'Question', 'Answer','questions', 'answers', 'users', 'user'];

export default QuestionsCtrl;
