import angular from 'angular';
import uiRouter from 'angular-ui-router';
import routing from './routing';

var answers = angular.module('wm.answers', [uiRouter, 'angular-carousel']);

answers.config(routing);

export default 'wm.answers';