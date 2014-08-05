# Editor takes care of the socket communication between client
# and the server and the storage to mongoDB for Research Documents
module.exports = (socket, mongoose, document) ->
    Delta = require('./models/Delta')(mongoose)

    # Function to save the delta and provide a standard response
    saveDelta = (delta, response) ->
      delta.save(
        (err) ->
          if err then response({code: 500, error: 'Error saving delta'})
          else response({code: 200})
          return
      )
      return

    # ------------ Protocol Implementation ------------
    socket.on('section.add', (data, response) ->
      section_id = data.section_id
      index = data.index

      delta = new Delta({
        document: document._id
        name: 'section.add'
        args: {section_id: section_id, index: index}
      })
      saveDelta(delta, response)
    )

    socket.on('section.delete', (data, response) ->
      section_id = data.section_id

      delta = new Delta({
        document: document._id
        name: 'section.delete'
        args: {section_id: section_id}
      })
      saveDelta(delta, response)
    )

    socket.on('subsection.add', (data, response) ->
      section_id = data.section_id
      subsection_id = data.subsection_id
      index = data.index

      delta = new Delta({
        document: document._id
        name: 'subsection.add'
        args: {section_id: section_id, subsection_id: subsection_id, index: index}
      })
      saveDelta(delta, response)
    )

    socket.on('subsection.delete', (data, response) ->
      section_id = data.section_id
      subsection_id = data.subsection_id

      delta = new Delta({
        document: document._id
        name: 'subsection.delete'
        args: {section_id: section_id, subsection_id: subsection_id}
      })
      saveDelta(delta, response)
    )