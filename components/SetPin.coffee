noflo = require 'noflo'
gpio = require 'node-gpio'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Set values on GPIO pin'

  c.io = null

  c.outPorts.add 'out'

  closeIO = ->
    if c.io
      c.io.close()
      c.io = null

  c.inPorts.add 'pin', (event, payload) ->
    return unless event is 'data'
    closeIO()
    c.io = new gpio.GPIO payload.toString()
    c.io.open()
    c.io.setMode gpio.OUT

  c.inPorts.add 'in', (event, payload) ->
    return unless event is 'data'
    return unless c.io

    payload = if typeof payload == 'string' then payload.toLowerCase() != 'false' else payload
    value = if payload then true else false
    state = if value then gpio.HIGH else gpio.LOW
    c.io.write state
    c.outPorts.out.send value
    c.outPorts.out.disconnect()

  return c
