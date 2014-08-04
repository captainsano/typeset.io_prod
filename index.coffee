cors = require('cors')
app = require('express')();
bodyParser = require('body-parser')
app.use(cors({origin: true, credentials: true})) # Enable CORS across the entire express app
app.use(bodyParser.json())

mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/typeset', (err) ->
  if err
    console.log('MongoDB connection failed!')
  else
    console.log('MongoDB Connected!')

    server = app.listen(8888, -> console.log('Listening on port ' + 8888))
    io = require('socket.io')(server);

    io.on('connection', (socket) ->
      console.log('New Socket Connected!')

      # Attach the document handler events
      require('./lib/doc')(socket, mongoose)

      socket.on('disconnect', (socket) ->
        console.log('Socket Disconnected!')
      )
    )

    # Obtain the Document model
    Document = require('./lib/models/Document')(mongoose)
    namespaces = []
    namespaceDefined = (docid) -> namespaces.indexOf(docid) >= 0

    # POST confirmation to create the socket namespace for
    # the particular document type.
    app.post('/research', (req, res) ->
      docid = req.param('docid')
      # TODO: Check for document existence and editing rights
      console.log('Setting up namespace for: ' + docid)
      Document.findOne({_id: docid}, (err, document) ->
        if err or not document
          console.log('Failed to setup namespace: ' + docid)
          res.json({
            code: 400
            error: 'Invalid Document'
          })
        else
          # Create a namespace for that socket and attach handlers, then respond
          if not namespaceDefined(docid)
            docSock = io.of('/' + docid)
            docSock.on('connection', (socket) ->
              console.log('Socket connected for document: ' + docid)

              require('./lib/research-editor')(socket, mongoose, document)

              socket.on('disconnect', (socket) ->
                console.log('Disconnected socket for ' + docid)
              )
            )
            res.json({
              code: 200
            })
            console.log('Setup namespace: ' + docid)
            namespaces.push(docid)
          else
            console.log('namespace and handler defined already!')
            res.json({
              code: 200
            })
      )
    )

  return
);