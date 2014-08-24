# Module provides the document browsing window for the application
angular.module('docbrowser', [
  'socket'
  'ts.util'
])

# Controller handles the entire docbrowser window.
angular
.module('docbrowser')
.controller('DocbrowserController', [
    '$scope', 'DocService', 'ActionSheetService', '$window'
    ($scope, DocService, ActionSheetService, $window) ->
      $scope.storage = DocService.storage
      $scope.listState = 'LOADING'  # Other States: LOADED and ERROR

      DocService.list().then(
        (docs) ->
          console.log('[DocBrowser]: Loaded docs')
          $scope.listState = 'LOADED'
        ,
        (error) ->
          # TODO: Handle Error
          console.log('[DocBrowser]: Error!')
          console.log(error)
          $scope.listState = 'ERROR'
      )

      $scope.newdoc = () ->
        ActionSheetService.show('NEW_DOC')

      # Opens document in a separate window
      $scope.openDoc = (docid) ->
        $window.open('research.html?d=' + docid, '_blank');

      $scope.deleteDoc = (doc, $event) ->
        ActionSheetService.show('DEL_DOC', doc)
        $event.stopPropagation();
  ])