# File attaches event handlers to the socket for document related events
# Events: doc.list, doc.create, doc.update, doc.delete
module.exports = (socket, mongoose) ->
  Document = require('./models/Document')(mongoose)

  socket.on('doc.list', (data, response) ->
    # Fetch the documents
    Document.find((err, result) ->
      if err
        response({
          code: 500
          error: 'Error fetching documents'
        })
      else
        response({
          code: 200
          data: result
        })
    )
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
