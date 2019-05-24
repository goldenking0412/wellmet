import angular from 'angular';

// 3rd party modules
import devise from './bower_components/AngularDevise/lib/devise';
import angularSanitize from 'angular-sanitize';
import angularjsAutocomplete from './bower_components/angularjs-autocomplete/build/angularjs-autocomplete';
import ngGeolocation from './bower_components/ngGeolocation/ngGeolocation';
import uibs from 'angular-ui-bootstrap';
import angularMoment from 'angular-moment';

// wm modules
import shared from './shared/shared';
import home from './home/home';
import interests from './interests/interests';
import users from './users/users';
import userInterests from './user_interests/user_interests';
import questions from './questions/questions';
import answers from './answers/answers';
import messages from './messages/messages';
import pages from './pages/pages';

// App config
import RunFunc from './config/run-func.js';
import ConfigFunc from './config/config-func';

// App level components
import HttpInterceptor from './config/http-interceptor';

var app = angular.module('wm', [
  'ui.bootstrap',
  home,
  interests,
  shared,
  users,
  userInterests,
  questions,
  answers,
  messages,
  pages,
  'Devise',
  'angularMoment',
  'angularjs-autocomplete',
  'ngGeolocation'
]);

app.factory('HttpInterceptor', HttpInterceptor);

app.config(ConfigFunc);
app.run(RunFunc);

export default app;
