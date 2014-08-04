# Delta is the model for storing various deltas
Delta = null

module.exports = (mongoose) ->
  if not Delta
    DeltaSchema = new mongoose.Schema({
      on: mongoose.Schema.Types.ObjectId              # On which object was the delta performed
      name: String                                    # Name of the delta
      timestamp: {type: Date, default: Date.now()}    # Time at which the delta was performed
#     by: mongoose.Schema.Types.ObjectId
      args: mongoose.Schema.Types.Mixed               # The arguments that are relevant for the delta
    })

    Delta = mongoose.model('Delta', DeltaSchema)

  # Return the model
  Delta