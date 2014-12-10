noflo = require 'noflo'
gpio = require 'node-gpio'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for changes to GPIO pin'

  c.io = null

  c.outPorts.add 'out'

  closeIO = ->
    if c.io
      c.io.close()
      c.io = null

  c.inPorts.add 'close', (event, payload) ->
    closeIO()
    c.outPorts.out.disconnect()

  c.inPorts.add 'pin', (event, payload) ->
    return unless event is 'data'

    closeIO()
    c.io = new gpio.GPIO payload.toString()
    c.io.open()
    c.io.setMode gpio.IN
    c.io.on 'changed', (value) ->
      c.outPorts.out.send value
    c.io.listen()

  return c
