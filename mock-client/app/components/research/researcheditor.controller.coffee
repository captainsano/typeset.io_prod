angular
.module('research')
.controller('ResearchEditorController', [
    '$scope', 'ResearchFactory'
    ($scope, ResearchFactory) ->
      $scope.status = 'CONNECTING' # Or: CONNECTED, DISCONNECTED, ERROR

      # Send a primary HTTP POST request to setup a namespace on server
      # for the current document id
      docid = $.QueryString['d']
      if docid
        console.log('[ResearchEditorController]: Connecting...')
        ResearchFactory.connect(docid).then(
          () ->
            console.log('[ResearchEditorController]: Connected')
          ,
          (error) ->
            console.log('[ResearchEditorController]: Connection Failed!')
            console.log(error)
        )
      else
        $scope.status = 'ERROR'

#      Extract from window location
#      document = $.QueryString['d']
#      console.log(document)

      # TODO: Fetch the latest version of the document

      $scope.storage = ResearchFactory.storage

      # UI Handling Methods
      $scope.addSection = (index) ->
        ResearchFactory.addSection(index)
        console.log('[ResearchEditorController]: Add Section ' + index)

      $scope.deleteSection = (id) ->
        ResearchFactory.deleteSection(id)
        console.log('[ResearchEditorController]: Delete Section ' + id)

      $scope.addSubSection = (section_id, index) ->
        ResearchFactory.addSubSection(section_id, index)
        console.log('[ResearchEditorController]: Add SubSection ' + section_id + ' ' + index)

      $scope.deleteSubSection = (section_id, subsection_id) ->
        ResearchFactory.deleteSubSection(section_id, subsection_id)
        console.log('[ResearchEditorController]: Delete SubSection ' + section_id + ' ' + subsection_id)
  ])