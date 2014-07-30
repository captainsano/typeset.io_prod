# Module creates and returns the document model
# Should act like a singleton
Document = null

module.exports = (mongoose) ->
  if not Document
    DocumentSchema = new mongoose.Schema({
      title: String
      createdAt: {type: Date, default: Date.now()}
    })

    Document = mongoose.model('Document', DocumentSchema)

  # Return the model
  Document

