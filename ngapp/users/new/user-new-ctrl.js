var locationRefusedModalTemplate = require('../edit/location-refused-modal.html');
var locationResponseModalTemplate = require('../edit/location-response-modal.html');

var UserNewCtrl = function($rootScope, $scope, $uibModal, $timeout, $window, $state, $http, User, Interest, UserInterest, Months, Years, Auth, $location, $anchorScroll){
  var vm = this;
  vm.currentStep = 0;
  vm.activeStep = 1;

  vm.Months = Months;
  vm.Years = Years;

  var saveUserInterest = function(){
    UserInterest.save({user_interest: {interest_id: vm.interest.id, comment: vm.comment, like: vm.like}});
  };

  var addInterest = function(){
    console.log("Interest function called");
    if(vm.interest.id){
      saveUserInterest();
    } else {
      Interest.save({interest: {name: vm.interest.name, category_id: vm.categoryId}}).then(function(response){
        var value = response.data;
        vm.interest.id = value.id;
        saveUserInterest();
      });
    }
  };

  vm.addInterest = function(){
    vm.activeStep = 2;
    console.log("true interest function called");
    vm.currentStep = 1;
    $location.hash("personalinfo");
    $anchorScroll();
  };

  vm.getInterests = function(value){
    return Interest.query({name_cont: value, category_id_eq: vm.categoryId}).then(function(response){
      var interests = response.data;

      var matchingInterest = interests.filter(function(i){
        return value.toLowerCase() === i.name.toLowerCase();
      })[0];

      if(!matchingInterest){
        response.data.unshift({name: value});
      }
      return response.data;
    }).catch(function (err) {});
  };

  vm.signUp = function(){
    var dateofbirth =  document.getElementById('datevalue').value;
    vm.user.date_of_birth = dateofbirth;
    Auth.register(vm.user).then(function(response){
      vm.activeStep = 3;
      vm.currentStep = 3;
      $rootScope.userInfo = response;
    }, function(response){
      vm.errors = response.data.errors;
      document.querySelector('#user-new-content').scrollTop = 0;
    });
  };

  // vm.update_current_location_new = function(user) {
  if($rootScope.lol) {
    var coordinate_value = $rootScope.lol;
  }
  else if($rootScope.co_ordinates) {
    var coordinate_value = $rootScope.co_ordinates;
  }
  console.log($rootScope.lol,$rootScope.co_ordinates, "any geo-update?");
  if($rootScope.lol || $rootScope.co_ordinates) {
    var coords = coordinate_value.latitude +"," + coordinate_value.longitude;
    var api_key = 'AIzaSyBxPXhX7mtb3M6eQxWc9qBqPcZj_YLqnY0';
    var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + coords + "&key=" + api_key;
    console.log(url, "===url===");
    $http.get(url).then( function(response) {
      console.log(response.data.results[0].formatted_address, "===response===");
      vm.user.location = response.data.results[0].formatted_address;
    }).catch(function(err){
      console.log(err, "--err---");
    });
  }
  else {
    console.log("no geo-update");
  }

  vm.completed = function(){
    $state.go('home').then(function(){
      addInterest();
      // $window.location.reload();
    });
  };

  vm.setActive = function(categoryid){
    vm.activeMenu = categoryid;
  };

  vm.scrollToInterestForm = function(){
    $timeout(function(){
      var panelTop = document.querySelector('#add-interest-panel').getBoundingClientRect().top;
      if(panelTop > 65){
        console.log("moving", panelTop)
         $location.hash("add-interest-panel");
         $anchorScroll();
        // document.querySelector('#user-new-content').scrollTop = document.querySelector('#user-new-content').scrollTop + panelTop - 60;
      }
    })
  }
};

UserNewCtrl.$inject = ['$rootScope', '$scope', '$uibModal', '$timeout', '$window', '$state', '$http', 'User', 'Interest', 'UserInterest', 'Months', 'Years', 'Auth','$location', '$anchorScroll'];

export default UserNewCtrl;
