# Directive to place focus on the element once linked
angular
.module('ts.util')
.directive('placeFocus', [
    '$timeout'
    ($timeout) ->
      {
        restrict: 'A',
        link: (scope, element) -> $timeout(() -> element.focus())
      }
  ])