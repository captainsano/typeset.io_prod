# Run Block to register the actionsheets
angular
.module('docbrowser')
.run([
    'ActionSheetService'
    (ActionSheetService) ->
      ActionSheetService.register('NEW_DOC', 'components/docbrowser/newdoc.html')
  ])

# Controller for the action sheet
angular
.module('docbrowser')
.controller('NewDocumentActionSheetController', [
    '$scope', 'ActionSheetService', 'DocService'
    '$window', '$location'
    ($scope, ActionSheetService, DocService, $window, $location) ->
      $scope.status = 'DEFAULT' # or: CREATING
      $scope.name = ''
      $scope.docType = ''

      $scope.cancel = () ->
        ActionSheetService.hide('NEW_DOC')

      $scope.createDocument = () ->
        $scope.status = 'CREATING'
        editor = $window.open('')
        $window.focus()

        DocService.create($scope.name).then(
          (doc) ->
            ActionSheetService.hide('NEW_DOC')
            editor.location = $window.location.pathname.replace('index.html', 'research.html?d=' + doc._id)
            editor.focus()
        )

  ])