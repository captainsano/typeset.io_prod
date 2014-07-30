# File attaches event handlers to the socket for document related events
# Events: doc.list, doc.create, doc.update, doc.delete
module.exports = (socket, mongoose) ->
  Document = require('./models/Document')(mongoose)

  socket.on('doc.list', (data, response) ->
    console.log('[Doc]: Listing...')
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

  socket.on('doc.rename', (data, response) ->
    console.log('[Doc]: Renaming...')
    Document.update({_id: data.id}, {title: data.title}, (err) ->
      if err
        response({
          code: 500
          error: 'Failed to update the title'
        })
      else
        response({code: 200})
    )
  )

  socket.on('doc.delete', (data, response) ->
    console.log('[Doc]: Deleting...')
    Document.remove({_id: data.id}, (err) ->
      if err
        response({
          code: 500
          error: 'Could not delete document'
        })
      else
        response({code: 200})
    )
  )
