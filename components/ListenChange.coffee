noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Apply a vignette effect to a given image.'

  c.canvas = null

  c.inPorts.add 'canvas', (event, payload) ->
    return unless event is 'data'

    c.outPorts.canvas.send canvas
  c.outPorts.add 'canvas'


  c

