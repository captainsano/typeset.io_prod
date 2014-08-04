# Stores the listeners for each event
listeners = {}

# Assigns listeners to the event
module.exports.on = (eventName, listener) ->
  if not listeners.hasOwnProperty(eventName) then listeners[eventName] = []
  console.log('Attaching event listener to ' + eventName)
  listeners[eventName].push(listener)

# Invokes the listeners of an event type
module.exports.invoke = (eventName, data, done) ->
  doneCount = 0;
  if listeners.hasOwnProperty(eventName) then listener(data,
    () ->
      doneCount += 1
      if doneCount == listeners[eventName].length then done()
  ) for listener in listeners[eventName]