cors = require('cors')
app = require('express')();
app.use(cors({origin: true, credentials: true})) # Enable CORS across the entire express app

mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/typeset', () ->
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

);

