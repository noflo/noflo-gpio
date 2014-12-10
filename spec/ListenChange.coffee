noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  ListenChange = require '../components/ListenChange.coffee'
  
describe 'ListenChange component', ->
  c = null
  inImage = null
  outImage = null

  beforeEach ->
    c = ListenChange.getComponent()
    pin = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.pin.attach pin
    c.outPorts.out.attach out
 
  describe 'when instantiated', ->
    it 'should have two input ports', ->
      chai.expect(c.inPorts.pin).to.be.an 'object'
      chai.expect(c.inPorts.close).to.be.an 'object'
    it 'should have one output port', ->
      chai.expect(c.outPorts.out).to.be.an 'object'

