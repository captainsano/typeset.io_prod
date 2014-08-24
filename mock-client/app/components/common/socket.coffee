## Module provides a service through which the underlying socket can be accessed
angular.module('socket', [])

angular.module('socket').factory('SocketService', [
  '$q'
  ($q) ->
    storage =
      socket: null

    # Method connects to the server, returns a promise that is
    # called back when connection succeeds.
    connect = (docid = null) ->
      deferred = $q.defer()
      console.log('[SocketService]: Connecting...' + docid)

      # TODO: Attach docid to the handshake in future version
      if not storage.socket
        if docid then storage.socket = io.connect('http://localhost:8888/' + docid)
        else storage.socket = io.connect('http://localhost:8888');

        storage.socket.on('connect', ->
          console.log('[SocketService]: Connected ' + docid)
          deferred.resolve()
        )
        storage.socket.on('connect_error', (err) ->
          console.log('[SocketService]: Connection Error ' + docid)
          console.log(err)
        )

      deferred.promise

    disconnect = () ->
      storage.socket?.disconnect()
      storage.socket = null
      return

    {
      connect: connect
      disconnect: disconnect
      socket: () -> storage.socket
    }
])