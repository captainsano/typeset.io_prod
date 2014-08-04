# Delta is the model for storing the changes to the document
Delta = null

module.exports = (mongoose) ->
  if not Delta
    DeltaSchema = new mongoose.Schema({
      document: mongoose.Schema.Types.ObjectId              # On which object was the delta performed
      name: String                                    # Name of the delta
      timestamp: {type: Date, default: Date.now()}    # Time at which the delta was performed
#     by: mongoose.Schema.Types.ObjectId
      args: mongoose.Schema.Types.Mixed               # The arguments that are relevant for the delta
    })

    Delta = mongoose.model('Delta', DeltaSchema)

  # Return the model
  Delta