# Module creates and returns the document model
# Should act like a singleton
Document = null

module.exports = (mongoose) ->
  if not Document
    DocumentSchema = new mongoose.Schema({
      title: {type: String, default: 'New Document'}
      createdAt: {type: Date, default: Date.now()}
#      createdBy: {type: mongoose.Schema.Types.ObjectId, default: ''}
    })

    Document = mongoose.model('Document', DocumentSchema)

  # Return the model
  Document

