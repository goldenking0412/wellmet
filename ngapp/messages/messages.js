import angular from 'angular';
import uiRouter from 'angular-ui-router';
import routing from './routing';

var messages = angular.module('wm.messages', [uiRouter]);

messages.config(routing);

export default 'wm.messages';