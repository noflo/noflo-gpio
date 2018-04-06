const noflo = require('noflo');
const gpio = require('rpi-gpio');

exports.getComponent = () => {
  const c = new noflo.Component();
  c.description = 'Listen for changes to a GPIO pin';
  c.icon = 'thumb-tack';
  c.inPorts.add('pin', {
    datatype: 'integer',
  });
  c.outPorts.add('out', {
    datatype: 'boolean',
  });
  c.outPorts.add('error', {
    datatype: 'object',
  });
  c.io = null;
  c.tearDown = (callback) => {
    if (!c.io) {
      callback();
      return;
    }
    c.io.gpio.destroy((err) => {
      if (err) {
        callback(err);
        return;
      }
      c.io.context.deactivate();
      c.io = null;
      callback();
    });
  };

  c.process((input, output, context) => {
    if (!input.hasData('pin')) {
      return;
    }
    const pin = input.getData('pin');
    gpio.setup(pin, gpio.DIR_IN, gpio.EDGE_BOTH, (err) => {
      if (err) {
        output.done(err);
        return;
      }
      c.io = {
        gpio,
        context,
      };
      gpio.on('change', (channel, val) => {
        if (channel !== pin) {
          return;
        }
        output.send({
          out: val,
        });
      });
    });
  });
};
