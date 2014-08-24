# Module provides a service to manage the sync functionality of deltas with the server.
angular
.module('delta')
.factory('DeltaService', [
    'SocketService', '$http', '$q'
    (SocketService, $http, $q) ->
      _storage =
        nextIdxToSync: 0
        deltas: []
        syncing: false      # Set to true when sync is in progress
        connected: false    # Set to true when connected TODO: Handle disconnection

      # Private method pushes deltas one by one to the server
      _sync = () ->
        _storage.syncing = true
        delta = _storage.deltas[_storage.nextIdxToSync]
        SocketService.socket()?.emit(delta.name, delta.args, (response) ->
          if response.code == 200
            _storage.deltas[_storage.nextIdxToSync].synced = true
            _storage.nextIdxToSync += 1
            if _storage.deltas.length > _storage.nextIdxToSync then _sync()
            else
              _storage.syncing = false
              console.log('[DeltaService]: All Synced!')
          else
            throw new Error('[DeltaService]: SyncFailure!')
        )

      # Method to establish connection for the document id
      _connect = (doctype, docid) ->
        deferred = $q.defer()
        console.log('[DeltaService]: Requesting namespace ' + docid)

        # TODO: Manually handle socket reconnection via POST
        $http.post('http://localhost:8888/' + doctype, {docid: docid}).then(
          (response) ->
            console.log(response)
            if response.data.code == 200
              document = response.data.data
              # Setup the socket connection
              console.log('[DeltaService]: Setting up the socket connection...')
              SocketService.connect(docid).then(
                () ->
                  console.log('[DeltaService]: Connected')
                  deferred.resolve(document)
              ,
              () ->
                console.log('[DeltaService]: Failed to connect!')
                deferred.reject()
              )
            else
              console.log('[DeltaService]: Failed to establish namespace')
              deferred.reject('Failed to connect')
        ,
        (error) ->
          console.log('[DeltaService]: Error: Failed to establish namespace')
          deferred.reject(error)
        )
        deferred.promise

      _addDelta = (delta) ->
        console.log('[DeltaService]: Adding Delta...')
        delta.synced = false
        _storage.deltas.push(delta)
        if not _storage.syncing then _sync()

      # TODO: Manage Undo/Redo stack using deltas

      {
        storage: _storage
        connect: _connect
        addDelta: _addDelta
      }
  ])