# Delta composer aggregates all the deltas in a document to return the final state
module.exports = (mongoose) ->
  Delta = require('./models/Delta')(mongoose)

  # Main aggregate function that composes delta accd. to
  # the research operations
  _aggregateDeltas = (deltas) ->
    document = {sections: []}
    cache = {}

    if deltas.length > 0
      for i in [0..deltas.length - 1]
        delta = deltas[i]
        args = delta.args
        switch(delta.name)
          # Add a section at given index
          when 'section.add'
            newSection =
              id: args.section_id
              title: ''
              contents: ''
              subsections: []

            document.sections.splice(args.index, 0, newSection)
            cache[args.section_id] = {item: newSection, container: document.sections}

          # Remove a section given its id
          when 'section.delete'
            hit = cache[args.section_id]
            if hit
              hit.container.splice(hit.container.indexOf(hit.item), 1)
              delete cache[args.section_id]

          # Add a subsection
          when 'subsection.add'
            # Find the section
            hit = cache[args.section_id] # Retrieve the section
            if hit
              newSubSection =
                id: args.subsection_id
                title: ''
                contents: ''
                subsubsections: []
              hit.item.subsections.splice(args.index, 0, newSubSection)
              cache[args.subsection_id] = {item: newSubSection container: hit.item}
          # Delete a subsection
          when 'subsection.delete'
            hit = cache[args.subsection_id]
            if hit
              hit.container.splice(hit.container.indexOf(hit.item), 1)
              delete cache[args.subsection_id]

          # Add a subsubsection
          when 'subsubsection.add'
            for i in [0..document.sections.length - 1]
              if document.sections[i].id == args.section_id
                for j in [0..document.sections[i].subsections.length - 1]
                  if document.sections[i].subsections[j].id == args.subsection_id
                    document.sections[i].subsections[j].subsubsections.splice(args.index, 0, {
                      id: args.subsubsection_id
                      title: ''
                      contents: ''
                    })
          # Delete a subsubsection
          when 'subsubsection.delete'
            for i in [0..document.sections.length - 1]
              if document.sections[i].id == args.section_id
                for j in [0..document.sections[i].subsections.length - 1]
                  if document.sections[i].subsections[j].id == args.subsection_id
                    for k in [0..document.sections[i].subsections[j].subsubsections.length - 1]
                      if document.sections[i].subsections[j].subsubsections[k].id == args.subsubsection_id
                        document.sections[i].subsections[j].subsubsections.splice(k, 1)
                        break

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
          document = _aggregateDeltas(deltas)
          callback?(null, document)
    )

  {
    compose: _compose
  }
