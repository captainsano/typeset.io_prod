angular
.module('ts.util')
.factory('ActionSheetService',[
    () ->
      _registeredSheets = {}
      _sheets =
        visibleSheets: []

      _register = (sheetName, templateURL) ->
        console.log('[ActionSheetService]: register')
        _registeredSheets[sheetName] = templateURL

      _unRegister = (sheetName) ->
        console.log('[ActionSheetService]: unRegister')
        if _registeredSheets.hasOwnProperty(sheetName)
          delete _registeredSheets[sheetName]

      _show = (sheetName, data = null) ->
        console.log('[ActionSheetService]: show')
        if _registeredSheets.hasOwnProperty(sheetName)
          _sheets.visibleSheets.push({
              templateURL: _registeredSheets[sheetName]
              data: if data then data else {}
          })

      _hide = (sheetName) ->
        console.log('[ActionSheetService]: hide')
        if _registeredSheets.hasOwnProperty(sheetName)
          # Nested function to hide the sheet at given index
          hideSheet = (sheetIdx) -> _sheets.visibleSheets.splice(sheetIdx, 1)

          # Nested function to find the index of visible sheet
          findSheetIdx = (templateURL) ->
            for i in [0..(_registeredSheets.length - 1)]
              if _sheets.visibleSheets[i].templateURL == templateURL then return i
            return null

          idx = findSheetIdx(_registeredSheets[sheetName])
          if idx >= 0 then hideSheet(idx)

      {
        sheets: _sheets
        register: _register
        unRegister: _unRegister
        show: _show
        hide: _hide
      }
  ])

angular
.module('ts.util')
.controller('ActionSheetController', [
    '$scope', 'ActionSheetService',
    ($scope, ActionSheetService) ->
      $scope.sheets = ActionSheetService.sheets
  ])