# Delta composer aggregates all the deltas in a document to return the final state
module.exports = (mongoose) ->
  Delta = require('./models/Delta')(mongoose)

  # Method to compose the document from deltas
  _compose = (docid, startingFrom, callback) ->
    Delta
    .find({document: docid})
    .sort('timestamp')
    .exec(
      (err, deltas) ->  # TODO: Include Starting from and fetch previous state from AWS S3
        if err
          console.log('Fetch Error!')
          console.log(err)
          callback?('Error Fetching Deltas!', null)
        else
          console.log('Fetched Deltas: ')
          console.log(deltas)
          callback?(null, {})
    )

  {
    compose: _compose
  }
