var ConfigFunc = function($httpProvider) {
  $httpProvider.interceptors.push('HttpInterceptor');
};

ConfigFunc.$inject = ['$httpProvider'];

export default ConfigFunc;
