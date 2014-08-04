# Editor takes care of the socket communication between client
# and the server and the storage to mongoDB for Research Documents
module.exports = (socket, mongoose, document) ->
    Delta = require('./models/Delta')(mongoose)

    socket.on('section.add', (data, response) ->
      section_id = data.section_id
      index = data.index

      delta = new Delta({
        document: document._id
        name: 'section.add'
        args: {section_id: section_id, index: index}
      })
      delta.markModified('args')
      delta.save(
        (err) ->
          if err
            response({
              code: 500,
              error: 'Error saving delta'
            })
          else
            response({
              code: 200    # Just send ACK
            })
      )
  )