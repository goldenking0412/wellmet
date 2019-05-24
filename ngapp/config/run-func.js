var RunFunc = function($location, $window, $http, $state, $rootScope, $uibModalStack, $geolocation, $timeout, Auth, Category, BannerManagement, $interval, Notifications, User, Logincm){
  $window.ga('create', 'UA-XXXXXXXX-X', 'auto');
  $http.defaults.paramSerializer = '$httpParamSerializerJQLike';
  $rootScope.$state = $state;
  Category.query().then(function(response){

    var value = response.data;
    value.unshift({name: 'All Categories'});

    $rootScope.categories = value;
    $rootScope.radius = [{id:"0",name:"Find Someone"},{id:"1",name:"Really Close"},{id:"2",name:"Close"},{id:"3",name:"Far"},{id:"4",name:"Really Far"},{id:"5",name:"Far Far away"}];

    $rootScope.categoryColors = value.map(function(r){ return r.color });
  });

  $rootScope.getHeight = function (selector) {
    var element = document.getElementById(selector)
    if(element){
    return "min-height: " + element.offsetHeight + "px" + " !important;";
  }
  };

  BannerManagement.query().then(function(response){
    var value = response.data;
    $rootScope.banner_mgmts = value;
  });


  Logincm.query().then(function(response){
    var value = response.data;
    $rootScope.logincms = value;
  });

  $rootScope.randomCategoryColor = function(){
    return $rootScope.categoryColors[Math.floor(Math.random()*$rootScope.categoryColors.length)];
  }

  $rootScope.generateNumber = function() {
    $rootScope.randomNumber = Math.floor(Math.random()*3+1);
    return $rootScope.randomNumber;
  };

  // $rootScope.closeSidebar= function() {
  //   angular.element(document.querySelector("#sidebar")).removeClass("sidebarjs--is-visible");
  // }

  try{
    $rootScope.userInfo = JSON.parse(localStorage.getItem('userInfo'));
  } catch(err){}

  Auth.login().then(function(response){
    $rootScope.userInfo = response;
    localStorage.setItem("userInfo", JSON.stringify(response));
    User.get(response.id).then(function(response){
      $rootScope.userSetting = response.user_setting
    });
  }, function(){
    delete $rootScope.userInfo;
    localStorage.setItem("userInfo", undefined);
  });

  $rootScope.logout = function(){
    var user_id = $rootScope.userInfo.id;
    var now = new Date();
    User.update(user_id, {last_logged_out_at: now}).then(function(response){
      console.log(now, "logged out time");
        });
    $rootScope.stateChangeInProgress = true;
    Auth.logout().then(function(){
      delete $rootScope.userInfo;
      $rootScope.stateChangeInProgress = false;
      $state.go('home');
    });
  };

  $rootScope.Auth = Auth;

  $rootScope.$on('$stateChangeStart', function(evt, to, params) {
    $uibModalStack.dismissAll('$stateChangeStart');
    $rootScope.stateChangeInProgress = true;
    $rootScope.header.menuExpanded = false;
    if(to.auth && !Auth.isAuthenticated()) {
      evt.preventDefault();
      $state.go('user-new', params, { location: 'replace' })
    }
  });

  $rootScope.$on('$stateChangeSuccess', function() {
    $window.ga('send', 'pageview', $location.path());
    if($window.location.pathname == "/help"){
      $rootScope.title = "Get help instantly| Meet the Most Interesting People|Make friends";
      $rootScope.description = "Get friend with someone around the globe, near or far with the help of Wellmet. You can click on any interest icon to view everyone with the same interest.";
    }
    else if($state.current.data && $state.current.data.title && $state.current.data.description){
      $rootScope.title = $state.current.data.title;
      $rootScope.description = $state.current.data.description;
    }
    $rootScope.stateChangeInProgress = false;
  });

  $geolocation.watchPosition({
    timeout: 60000,
    maximumAge: 250,
    enableHighAccuracy: true
  });


  var shouldSoundNotification = function(oldNotifications, newNotifications){
    if(oldNotifications && $rootScope.userSetting && $rootScope.userSetting.sound_notification){
      var anyIncrease = false
      for(var key in oldNotifications){
        if(oldNotifications[key] < newNotifications[key]){
          anyIncrease = true
        }
      }
      return anyIncrease
    }

  }

  var loadNotifications = function(){
    if(Auth.isAuthenticated()){
      Notifications.query().then(function(response){
        if(shouldSoundNotification($rootScope.header.notifications, response)){
          document.querySelector('#notificationSound').play()
        }
        $rootScope.header.notifications = response.data;
      });
    }
  };

  var notificationDelay= function(){
    if(mobileAndTabletcheck()){
      return 10000
    } else {
      return 5000
    }
  }

  $rootScope.header = {};
  loadNotifications()
  $interval(loadNotifications, notificationDelay());
};

RunFunc.$inject = ['$location', '$window', '$http', '$state', '$rootScope', '$uibModalStack', '$geolocation', '$timeout', 'Auth', 'Category', 'BannerManagement', '$interval', 'Notifications', 'User', 'Logincm'];

export default RunFunc;
