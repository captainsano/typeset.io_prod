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
        return
      else
        response({
          code: 200
          data: result
        })
        return
    )
  )

  socket.on('doc.create', (data, response) ->
    console.log('[Doc]: Creating...')
    document = new Document({title: data.title})
    document.save((err) ->
      if err
        response({
          code: 500
          error: 'Error creating new document'
        })
        return
      else
        response({
          code: 200
          data: document
        })
        return
    )
  )

  socket.on('doc.rename', (data, response) ->
    console.log('[Doc]: Renaming...')
    Document.update({_id: data.id}, {title: data.title}, (err) ->
      if err
        response({
          code: 500
          error: 'Failed to update the title'
        })
        return
      else
        response({code: 200})
        return
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
        return
      else
        response({code: 200})
        return
    )
  )
