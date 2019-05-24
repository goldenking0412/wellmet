import angular from 'angular';
import routing from './routing.js';
require('angular-ui-bootstrap-datetimepicker');
require('ng-file-upload');
require('ng-img-crop-full-extended');
require('ng-autocomplete');
require('angular-route');
import HttpInterceptor from '../config/http-interceptor';
import ngGeolocation from '../bower_components/ngGeolocation/ngGeolocation';

var users = angular.module('wm.users', ['ui.bootstrap.datetimepicker', 'ngFileUpload', 'ngImgCrop', 'ngAutocomplete', 'ngGeolocation', 'ngRoute']);

users.factory('HttpInterceptor', HttpInterceptor);
users.config(routing);

export default 'wm.users'