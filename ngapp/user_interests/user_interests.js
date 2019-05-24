import angular from 'angular';
import routing from './routing.js';

var users = angular.module('wm.userInterests', []);

users.config(routing);

export default 'wm.userInterests'