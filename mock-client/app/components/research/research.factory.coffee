# Service keeps the data in sync and acts as a data storage mechanism also.
# Each change in the data model is supposed to be notified to the sync service
angular
.module('research')
.factory('ResearchFactory', [
    'UUIDFactory', 'DeltaService', '$q'
    (UUIDFactory, DeltaService, $q) ->

      # Object stores all the sections
      _storage =
        document: {sections: []}

      _connect = (docid) ->
        deferred = $q.defer()

        console.log('[ResearchFactory]: Connecting...')
        DeltaService.connect('research', docid).then(
          (document) ->
            console.log('[ResearchFactory]: Connected ' + docid)
            _storage.document = document
            console.log(document)
            deferred.resolve()
          ,
          (error) ->
            console.log('[ResearchFactory]: Connection Failed!')
            deferred.reject(error)
        )

        deferred.promise

      # Method to add a new section -> Returns section id
      _addSection = (index) ->
        console.log('[ResearchFactory]: Add Section')
        newSection = null
        if index > _storage.document.sections.length
          console.log('[ResearchFactory]: Error! Invalid Index!')
        else
          newSection = {
            id: UUIDFactory.generateShortUUID()
            title: ''
            contents: ''
            subsections: []
          }
          _storage.document.sections.splice(index, 0, newSection)

          DeltaService.addDelta({
            name: 'section.add',
            args: {section_id: newSection.id, index: index}
          })

      _deleteSection = (id) ->
        console.log('[ResearchFactory]: Delete Section')
        for i in [0.._storage.document.sections.length - 1]
          if _storage.document.sections[i].id == id
            _storage.document.sections.splice(i, 1)
            DeltaService.addDelta({
              name: 'section.delete'
              args: {section_id: id}
            })
            break

      # Method to add a new subsection -> Returns subsection id
      _addSubSection = (section_id, index) ->
        console.log('[ResearchFactory]: Add SubSection')
        for i in [0.._storage.document.sections.length - 1]
          if _storage.document.sections[i].id == section_id
            newSubSection = null
            if index > _storage.document.sections[i].subsections.length
              console.log('[ResearchFactory]: Error! Invalid Index!')
            else
              newSubSection = {
                id: UUIDFactory.generateShortUUID()
                title: ''
                contents: ''
                subsubsections: []
              }
              _storage.document.sections[i].subsections.splice(index, 0, newSubSection)
              DeltaService.addDelta({
                name: 'subsection.add'
                args: {section_id: section_id, subsection_id: newSubSection.id, index: index}
              })
              break

      _deleteSubSection = (section_id, subsection_id) ->
        console.log('[ResearchFactory]: Delete SubSection')
        for i in [0.._storage.document.sections.length - 1]
          if _storage.document.sections[i].id == section_id
            for j in [0.._storage.document.sections[i].subsections.length - 1]
              if _storage.document.sections[i].subsections[j].id == subsection_id
                _storage.document.sections[i].subsections.splice(j, 1)
                DeltaService.addDelta({
                  name: 'subsection.delete'
                  args: {section_id: section_id, subsection_id: subsection_id}
                })
                break

      # Method to add a new subsubsection

      {
        storage: _storage
        connect: _connect
        addSection: _addSection
        deleteSection: _deleteSection
        addSubSection: _addSubSection
        deleteSubSection: _deleteSubSection
      }
  ])