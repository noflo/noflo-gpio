const noflo = require('noflo');
const path = require('path');
const { expect } = require('chai');

describe('SetPin component', () => {
  let c = null;
  before((done) => {
    const baseDir = path.resolve(__dirname, '../');
    const loader = new noflo.ComponentLoader(baseDir);
    loader.load('gpio/SetPin', (err, instance) => {
      if (err) {
        done(err);
        return;
      }
      c = instance;
      done();
    });
  });
  describe('when instantiated', () => {
    it('should have two input ports', () => {
      expect(Object.keys(c.inPorts.ports)).to.eql([
        'pin',
        'in',
      ]);
    });
    it('should have two input ports', () => {
      expect(Object.keys(c.outPorts.ports)).to.eql([
        'out',
        'error',
      ]);
    });
  });
});
