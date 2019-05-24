var HttpInterceptor = function($geolocation, $rootScope){
  console.log("geolocation");
  return {
    request: function(config) {
      $rootScope.nav = navigator.geolocation.getCurrentPosition(function(position) {
        var lat = position.coords.latitude;
        var long = position.coords.longitude;
        console.log(lat, long, "navigator.coordinates");
        $rootScope.co_ordinates = position.coords;
        return $rootScope.co_ordinates;
      });
      if($geolocation.position.coords){
        // config.headers.Location = $geolocation.position.coords.latitude + ',' + $geolocation.position.coords.longitude;
        console.log($geolocation.position.coords.latitude, $geolocation.position.coords.longitude, "$geolocation.position");
      }
      $geolocation.watchPosition({
        timeout: 60000,
        maximumAge: 250,
        enableHighAccuracy: true
      });
      var coordinat = $geolocation.position.coords;
      $rootScope.lol = coordinat;
      return config;
    }
  };
};

HttpInterceptor.$inject = ['$geolocation', '$rootScope'];

export default HttpInterceptor;
