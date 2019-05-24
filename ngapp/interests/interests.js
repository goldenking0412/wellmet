import angular from 'angular';
import uiRouter from 'angular-ui-router';
import routing from './routing';

var interests = angular.module('wm.interests',[uiRouter]);

interests.config(routing);

export default 'wm.interests';
