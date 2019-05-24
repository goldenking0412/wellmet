var successModalTemplateUrl = require('./success-modal.html');
var UserNewCtrl = function($rootScope, $uibModal, $stateParams, Question, Answer, questions){
  var vm = this;

  vm.questions = questions.data;
  vm.color = $rootScope.randomCategoryColor();
  vm.questionIndex = 0;

  vm.radiuses = [{id:"0",value:"All"},{id:"1",value:"Really Close"},{id:"2",value:"Close"},{id:"3",value:"Far"},{id:"4",value:"Really Far"},{id:"5",value:"Far Far away"}];


  vm.saveAnswer = function(questionid){
    var text =  document.getElementById('answertext-'+ questionid.toString()).value;
    Answer.save({question_id: questionid,user_id: $rootScope.userInfo.id,text: text}).then(function(response){
      var value = response.data;
      vm.answer = value;
      $uibModal.open({
        templateUrl: successModalTemplateUrl,
        windowClass: 'center-modal'
      });
    }).catch(function (err) {}).finally(function(){
      });
  };

  if($stateParams.radius){
    Question.query({
        limit: 5,
        random: 'random',
        user_id_not_eq: $rootScope.userInfo && $rootScope.userInfo.id,
        radius: $stateParams.radius
      }).then(function(response){
        var value = response.data;
        if(value.length > 0){
          vm.questions = value;
        } else {
          vm.questions.length = 0;
        }
      }).catch(function (err)
      {}).finally(function(){
      });

  }
};

UserNewCtrl.$inject = ['$rootScope', '$uibModal', '$stateParams', 'Question', 'Answer', 'questions'];

export default UserNewCtrl;
