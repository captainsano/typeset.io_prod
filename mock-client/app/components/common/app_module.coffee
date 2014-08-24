
angular.module('ts', [
  'docbrowser'
  'ui.router'
  'socket'
])

angular
.module('ts')
.config([
    '$stateProvider', '$urlRouterProvider'
    ($stateProvider, $urlRouterProvider) ->
      $urlRouterProvider.otherwise('/');

      $stateProvider
      .state('docs', {
          url: '/'
          templateUrl: 'components/docbrowser/browser.html'
          controller: 'DocbrowserController'
        })
  ])

# Stub to connect the socket
angular
.module('ts')
.run([
    'SocketService',
    (SocketService) ->
      SocketService.connect()
  ])