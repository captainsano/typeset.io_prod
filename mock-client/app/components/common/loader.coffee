# Module provides a service as well as a controller to handle
# the loader box.
angular
.module('ts.util')
.factory('LoaderBoxService', [
    () ->
      loader =
        refCount: 0

      _display = () ->
        if loader.refCount >= 0 then loader.refCount += 1
        else loader.refCount = 1

      _hide = () ->
        if loader.refCount > 0 then loader.refCount -= 1
        else loader.refCount = 0

      {
        loader: loader
        display: _display
        hide: _hide
      }
  ])

angular
.module('ts.util')
.controller('LoaderBoxController', [
    '$scope', 'LoaderBoxService',
    ($scope, LoaderBoxService) ->
      $scope.loader = LoaderBoxService.loader
  ])