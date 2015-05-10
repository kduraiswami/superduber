var superduber = angular.module('superduber', ['ngRoute']);


superduber.config(function ($routeProvider) {
  $routeProvider
    .when('/', {
      controller: 'HomeController',
      templateUrl: 'events.html'
    })
    .otherwise({
      redirectTo: '/'
    });
});


superduber.controller('HomeController', ['$scope', 'events', function($scope, events) {
    events.success(function(data){
      $scope.user = data.user;
      $scope.events = data.events;
      console.log("USER UUID");
      console.log(data.user.uuid);
    })
}]);


superduber.factory('events', ['$http', function($http) {
  return $http.get('/user_events')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);



