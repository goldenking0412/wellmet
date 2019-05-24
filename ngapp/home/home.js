import angular from 'angular';
import uiRouter from 'angular-ui-router';
import routing from './routing.js';
require('angular-route');

var home = angular.module('wm.home',[uiRouter,'angular-carousel','ngSidebarJS','ngRoute'])

home.config(routing)

export default 'wm.home';
