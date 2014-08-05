# Stores the listeners for each event
listeners = {}

# Assigns listeners to the event
module.exports.on = (eventName, listener) ->
  if not listeners.hasOwnProperty(eventName) then listeners[eventName] = []
  console.log('Attaching event listener to ' + eventName)
  listeners[eventName].push(listener)

# Remove all event listeners for all event Names
module.exports.offAll = () ->
  listeners = {}
  return

# Invokes the listeners of an event type
module.exports.invoke = (eventName, data, done) ->
  doneCount = 0;
  _results = [];
  if listeners.hasOwnProperty(eventName) then listener(data,
    (result) ->
      doneCount += 1
      _results.push(result);
      if doneCount == listeners[eventName].length then done(_results)
    ) for listener in listeners[eventName]
  else
    # In case there are no listeners
    done([]);