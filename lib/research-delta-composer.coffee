# Delta composer aggregates all the deltas in a document to return the final state
module.exports = (mongoose) ->
  Delta = require('./models/Delta')(mongoose)

  # Main aggregate function that composes delta accd. to
  # the research operations
  _aggregateDeltas = (deltas) ->
    document = {sections: []}
    if deltas.length > 0
      for i in [0..deltas.length - 1]
        delta = deltas[i]
        args = delta.args
        switch(delta.name)
          when 'section.add'
            document.sections.splice(args.index, 0, {
              id: args.section_id
              title: ''
              contents: ''
              subsections: []
            })
    return document

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
          document = _aggregateDeltas(deltas)
          console.log(document)
          callback?(null, document)
    )

  {
    compose: _compose
  }
