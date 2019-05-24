var successModalTemplateUrl = require('./success-modal.html');
var interestTemplateUrl = require('./interest-modal.html');

var UserInterestNewCtrl = function($scope, $uibModal, $stateParams, $timeout, User, UserInterest, Interest, interest, user, $location, $anchorScroll){
  $timeout(function(){
    document.querySelector('#add-interest-panel').scrollIntoView();
  });

  var vm = this;
  vm.scrollup = function(){
    $location.hash("add-interest-side-panel");
    $anchorScroll();
  };

  vm.user = user.data;

  if(interest){
    vm.interest = interest.data;
    vm.like = true;
  }

  var saveUserInterest = function(){
    if(vm.user.provider && vm.user.policy == false)
    {
      $uibModal.open({
          scope: $scope,
          templateUrl: successModalTemplateUrl,
          windowClass: 'center-modal',
          backdropClass: 'no-click'
      })
    }
    else{
      UserInterest.save({user_interest: {interest_id: vm.interest.id, comment: vm.comment, like: vm.like}}).then(function(){
        $uibModal.open({
          scope: $scope,
          templateUrl: successModalTemplateUrl,
          windowClass: 'center-modal',
          backdropClass: 'no-click'
      })

      }).catch(function(response){
          var value = response.data;
          $uibModal.open({
          scope: $scope,
          templateUrl: interestTemplateUrl,
          windowClass: 'center-modal',
          backdropClass: 'no-click'
        })
      });
    }
  };

  vm.addInterest = function(){
    console.log("function called");
    if(vm.interest.id){
      saveUserInterest();
    } else {
      Interest.save({interest: {name: vm.interest.name || vm.interest, category_id: $stateParams.category_id}}).then(function(response){
        var value = response.data;
        vm.interest.id = value.id;
        saveUserInterest();
      }).catch(function(response){
        var value = response.data;
        $uibModal.open({
        scope: $scope,
        templateUrl: interestTemplateUrl,
        windowClass: 'center-modal',
        backdropClass: 'no-click'
    })
      });
    }
  };

  if($stateParams.category_id){
    vm.activeMenu = $stateParams.category_id;
  };

  vm.getInterests = function(value){
    return Interest.query({name_cont: value, not_added: true, category_id_eq: $stateParams.category_id}).then(function(response){
      var interests = response.data;

      var matchingInterest = interests.filter(function(i){
        return value.toLowerCase() === i.name.toLowerCase();
      })[0];

      if(!matchingInterest){
        response.data.unshift({name: value});
      }
      return response.data;
    });
  };
};

UserInterestNewCtrl.$inject = ['$scope', '$uibModal', '$stateParams', '$timeout', 'User', 'UserInterest', 'Interest', 'interest', 'user', '$location', '$anchorScroll'];

export default UserInterestNewCtrl;
