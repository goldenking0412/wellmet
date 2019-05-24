require('isotope-packery');
var Isotope = require('isotope-layout');

var wmIsotope = function($timeout){
  return {
    link: function(scope, element){
      $timeout(function(){
        var iso = new Isotope( element[0], {
          itemSelector: '.item',
          layoutMode: 'packery'
        });
      });
    }
  };
};

wmIsotope.$inject = ['$timeout'];

export default wmIsotope;