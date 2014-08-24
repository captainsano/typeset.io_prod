angular.module('research', [
  'ui.router'
  'socket'
  'delta'
  'ts.util'
  'monospaced.elastic'
])

angular
.module('research')
.config([
    '$stateProvider', '$urlRouterProvider'
    ($stateProvider, $urlRouterProvider) ->
      $urlRouterProvider.otherwise('/');

      $stateProvider
      .state('edit', {
          url: '/'
          templateUrl: 'components/research/editor.html'
          controller: 'ResearchEditorController'
        })
  ])

# Stub to connect the socket
#angular
#.module('ts')
#.run([
#    'SocketService',
#    (SocketService) ->
#      SocketService.connect()
#  ])