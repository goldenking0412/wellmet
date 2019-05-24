import angular from 'angular';
import uiRouter from 'angular-ui-router';
import routing from './routing';

var questions = angular.module('wm.questions', [uiRouter]);

questions.config(routing);

export default 'wm.questions';
