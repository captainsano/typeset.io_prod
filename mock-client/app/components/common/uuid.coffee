angular
.module('ts.util')
.factory('UUIDFactory', [
    () ->
      # My own hack!
      _generateShortUUID = () ->
        ("0000" + (Math.random()*Math.pow(36,4) << 0).toString(36)).substr(-4)

      # UUID Generation: // https://www.ietf.org/rfc/rfc4122.txt - some stackoverflow question
      _generateUUID = () ->
        d = new Date().getTime()
        uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
          r = (d + Math.random() * 16 ) % 16 | 0
          d = Math.floor(d / 16)
          (c == 'x' ? r : (r & 0x7 | 0x8)).toString(16)
        )
        uuid

      {
        generateShortUUID: _generateShortUUID
        generateUUID: _generateUUID
      }
  ])