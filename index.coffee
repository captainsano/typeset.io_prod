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

    app.post('/research', (req, res) ->
      docid = req.param('docid')
      # TODO: Check for document existence and editing rights
      Document = require('./lib/models/Document')(mongoose)
      Document.findOne({_id: docid}, (err, document) ->
        if err or not document
          res.json({
            code: 400
            error: 'Invalid Document'
          })
        else
          # Create a namespace for that socket and attach handlers, then respond
          docSock = io.of('/' + docid)
          docSock.on('connection', (socket) ->
            console.log('Socket connected for document: ' + docid)
            require('./lib/research/editor')(socket, mongoose)
          )
          res.json({
            code: 200
          })
      )
    )

  return
);