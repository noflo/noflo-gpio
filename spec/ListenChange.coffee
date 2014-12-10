noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  ListenChange = require '../components/ListenChange.coffee'
  
describe 'ListenChange component', ->
  c = null
  inImage = null
  outImage = null

  beforeEach ->
    c = ApplyVignette.getComponent()
    inImage = noflo.internalSocket.createSocket()
    outImage = noflo.internalSocket.createSocket()
    c.inPorts.canvas.attach inImage
    c.outPorts.canvas.attach outImage
 
  describe 'when instantiated', ->
    it 'should have one input port', ->
      chai.expect(c.inPorts.canvas).to.be.an 'object'
    it 'should have one output port', ->
      chai.expect(c.outPorts.canvas).to.be.an 'object'

