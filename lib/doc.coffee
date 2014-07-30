# File attaches event handlers to the socket for document related events
# Events: doc.list, doc.create, doc.update, doc.delete
module.exports = (socket) ->
  socket.on('doc.list', (data, response) ->
    # Fetch the documents
    response({
      code: 200
      data: [
        {id: 1, name: 'Untitled 1', created: Date.now()}
        {id: 2, name: 'Untitled 1', created: Date.now()}
        {id: 3, name: 'Untitled 1', created: Date.now()}
      ]
    })
  )

  socket.on('doc.create', (data, response) ->
    # TODO: Create a new document
  )

  socket.on('doc.update', (data, response) ->
    # TODO: Update a document
  )

  socket.on('doc.delete', (data, response) ->
    # TODO: Delete a document
  )
