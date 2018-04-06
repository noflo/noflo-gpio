const noflo = require('noflo');
const gpio = require('rpi-gpio');

// @runtime noflo-nodejs

exports.getComponent = () => {
  const c = new noflo.Component();
  c.description = 'Set values on a GPIO pin';
  c.icon = 'thumb-tack';
  c.inPorts.add('pin', {
    datatype: 'integer',
    control: true,
  });
  c.inPorts.add('in', {
    datatype: 'boolean',
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
      c.io = null;
      callback();
    });
  };
  c.process((input, output) => {
    if (!input.hasData('pin', 'in')) {
      return;
    }
    const [pin, value] = input.getData('pin', 'in');
    const boolValue = (String(value) === 'true');
    gpio.setup(pin, gpio.DIR_OUT, (err) => {
      if (err) {
        output.done(err);
        return;
      }
      c.io = {
        gpio,
      };
      gpio.write(pin, boolValue, (e) => {
        if (e) {
          output.done(e);
        }
        output.sendDone({
          out: boolValue,
        });
      });
    });
  });
  return c;
};
