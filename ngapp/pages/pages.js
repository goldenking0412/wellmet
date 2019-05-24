import angular from 'angular';
import uiRouter from 'angular-ui-router';
import routing from './routing';

var pages = angular.module('wm.pages',[uiRouter]);

pages.config(routing);

export default 'wm.pages';
