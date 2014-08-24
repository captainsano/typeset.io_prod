# Service provides convenience methods for handling documents
# by wrapping the direct calls via socket
angular
.module('docbrowser')
.factory('DocService', [
    'SocketService', '$q'
    (SocketService, $q) ->
      _storage =
        docs: []
      # TODO: Auto-Refresh the docs list storage every 'n' seconds

      # Method to list all the documents
      _list = () ->
        deferred = $q.defer()

        SocketService.socket()?.emit('doc.list', null, (response) ->
          if response.code == 200
            _storage.docs = response.data
            deferred.resolve(response.data)
          else
            deferred.reject(response.error)
        )

        deferred.promise

      # Method creates a new document
      _create = (name = 'New Document') ->
        console.log('[DocService]: creating ' + name)
        deferred = $q.defer()

        SocketService.socket()?.emit('doc.create', {name: name}, (response) ->
          if response.code == 200
            _storage.docs.unshift(response.data)  # Add document to the head of the list
            deferred.resolve(response.data)
          else
            deferred.reject(response.error)
        )

        deferred.promise

      # Method renames a document
      _rename = (id, name) ->
        deferred = $q.defer()

        SocketService.socket()?.emit('doc.rename', {id: id, name: name}, (response) ->
          if response.code == 200 then deferred.resolve() # TODO: Rename document in local cache
          else deferred.reject(response.error)
        )

        deferred.promise

      # Method deletes the document
      _delete = (id) ->
        deferred = $q.defer()

        SocketService.socket()?.emit('doc.delete', {id: id}, (response) ->
          if response.code == 200
            # Remove the document from storage
            for i in [0..(_storage.docs.length - 1)]
              if _storage.docs[i]._id == id
                _storage.docs.splice(i, 1)
                break
            deferred.resolve()
          else
            deferred.reject(response.error)
        )

        deferred.promise

      {
        storage: _storage
        create: _create
        rename: _rename
        delete: _delete
        list: _list
      }
  ])