var locationRefusedModalTemplate = require('../edit/location-refused-modal.html');
var locationResponseModalTemplate = require('../edit/location-response-modal.html');

var UsersCtrl = function($rootScope, $uibModal, $state, $http, $geolocation, HttpInterceptor, $stateParams, User, Hail, interests, user, Ages){
  var vm  = this;
  vm.user = user.data;

  var defaultLocateSettings = {
    ages: { '19u': vm.user && vm.user.age < 19,  '19a': vm.user && vm.user.age >= 19 },
    common_interests_count: 0,
    radius: 1000
  };

  vm.locateSettings = (user.data && user.data.user_setting) || angular.copy(defaultLocateSettings)

  vm.interests = interests.data;

  vm.availableSortParams = [
    { id: 'radius_asc', name: 'List by Radius' },
    { id: 'common_interests_count_desc', name: 'List by Common Interest' },
    { id: 'gender_asc', name: 'List by Gender'}
  ];

  $rootScope.options = null;
  $rootScope.details = '';

  console.log($rootScope.lol,$rootScope.co_ordinates , "any geo-update?");

  if($stateParams.radius_id != null)
  {
    vm.radiusname = ["Find Someone", "Really Close","Close","Far", "Really Far","Far Far away"]
    vm.radiiname = vm.radiusname[$stateParams.radius_id];
  }
  else
  {
    vm.radiusname = ["Find Someone", "Really Close","Close","Far", "Really Far","Far Far away"]
    vm.radiiname = vm.radiusname[vm.locateSettings.radius_id];
  }

  vm.sortBy = 'radius_asc';
  vm.radiusid = $stateParams.radius_id;
  $rootScope.location_update = function(user_id, posit) {
    User.update(user_id, {location: posit}).then(function(response){
      $rootScope.stateChangeInProgress = true;
      $state.go('users', { radius_id: vm.radiusid }, {reload: true});
      $rootScope.stateChangeInProgress = false;
      console.log(posit,response, "new location updated");
    }).catch(function (err) {
      console.log(err, "---err---");
      $state.go('users', { radius_id: vm.radiusid }, {reload: true});
      $rootScope.stateChangeInProgress = false;
    }).finally(function(){
      console.log("===finally===");
    });
  }

  $rootScope.current_location_update = function(user_id, latlng) {
    if(latlng) {
      var coordinate_value = latlng;
    }
    else if($rootScope.lol) {
      var coordinate_value = $rootScope.lol;
    }
    else if($rootScope.co_ordinates) {
      var coordinate_value = $rootScope.co_ordinates;
    }
    if(latlng || $rootScope.lol || $rootScope.co_ordinates) {
      var coords = coordinate_value.latitude +"," + coordinate_value.longitude;
      var api_key = 'AIzaSyBxPXhX7mtb3M6eQxWc9qBqPcZj_YLqnY0';
      var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + coords + "&key=" + api_key;
      console.log(url, "===url===");
      $http.get(url).then( function(response) {
        console.log(response.data.results[0].formatted_address, "===response===");
        $rootScope.current_location = response.data.results[0].formatted_address;
        $state.go('users', { radius_id: vm.radiusid }, {reload: true});
        $rootScope.location_update(user_id, $rootScope.current_location);
      }).catch(function(err){
        console.log(err, "===err===");
        $state.go('users', { radius_id: vm.radiusid }, {reload: true});
        $uibModal.open({
          templateUrl: locationResponseModalTemplate,
          windowClass: 'center-modal',
        })
      });
    }
    else {
      event.preventDefault();
      $state.go('users', { radius_id: vm.radiusid });
      $uibModal.open({
        templateUrl: locationRefusedModalTemplate,
        windowClass: 'center-modal',
      })
    }
  }

  vm.locate = function() {
    var specificInterestIds = []
    for(var key in vm.searchInterests){
      if(vm.searchInterests[key]){
        specificInterestIds.push(key)
      }
    }
    if(!$stateParams.radius_id)
      var params = {limit: 8,specific_interest_ids: specificInterestIds, sort: vm.sortBy, for_locate: false}
    else
      var params = {limit: 8, category_id: $stateParams.category_id, specific_interest_ids: specificInterestIds, sort: vm.sortBy, for_locate: true}


    if(vm.user){
      params.id_not_eq = vm.user.id;
    }

    var params = angular.extend(params, vm.locateSettings);
    delete(params.allow_to_locate_me)
    if($stateParams.radius_id){
      params.radius_id = $stateParams.radius_id
    }
    User.query(params).then(function(response){
      var value = response.data;
      vm.users = value;
      $rootScope.stateParamsateChangeInProgress = true;
    }).catch(function (err) {}).finally(function(){
      $rootScope.stateChangeInProgress = false;
    });
  };


  vm.ages = Ages;

  vm.hail = function(user, hailMessage){
    user.hailingInProgress = true
    Hail.save({hail: {to_user_id: user.id, message: hailMessage}}).then(function(){
      user.hailing = false;
      user.hailed = true;
    }).catch(function (err) {}).finally(function(){
      user.hailingInProgress = false
    });
  };

  vm.locate();
};

UsersCtrl.$inject = ['$rootScope', '$uibModal', '$state', '$http', '$geolocation', 'HttpInterceptor', '$stateParams', 'User', 'Hail', 'interests', 'user', 'Ages'];

export default UsersCtrl;
