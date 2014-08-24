angular
.module('docbrowser')
.run([
    'ActionSheetService'
    (ActionSheetService) -> ActionSheetService.register('DEL_DOC', 'components/docbrowser/deldoc.html')
  ])

angular
.module('docbrowser')
.controller('DeleteDocumentActionSheetController', [
    '$scope', 'DocService', 'ActionSheetService'
    ($scope, DocService, ActionSheetService) ->
      $scope.status = 'DEFAULT' # Or: DELETING
      $scope.doc = $scope.sheetData

      $scope.no = () -> ActionSheetService.hide('DEL_DOC')

      $scope.yes = () ->
        $scope.status = 'DELETING'
        DocService.delete($scope.doc._id).then(
          () ->
            console.log('Deleted Document')
            ActionSheetService.hide('DEL_DOC')
          ,
          (error) ->
            console.log('Error: ' + error)
        )
  ])