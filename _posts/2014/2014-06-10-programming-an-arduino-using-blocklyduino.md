---
layout: default
title: Programming an Arduino using BlocklyDuino
tags: arduino scratch blocklyduino
comments: true
---

[Blockly](https://developers.google.com/blockly/) is an experimental drag-and-drop programming environment not unlike [Scratch](http://scratch.mit.edu/). [BlocklyDuino](http://blocklyduino.github.io/BlocklyDuino/blockly/apps/blocklyduino/) is based on Blockly and provides an [open source](https://github.com/BlocklyDuino/BlocklyDuino) drag-and-drop programming editor for Arduino. It doesn't yet build the resulting code, but you can copy-paste it into the Arduino IDE.

Here's something quick I built to try it out. If an input digital pin is logic high, it prints text to the serial port.

![BlocklyDuino Editor](/assets/img/arduino-blocklyduino.png)

Try and make it yourself, or open the following XML using BlocklyDuino's Load XML feature.

```xml
<xml xmlns="http://www.w3.org/1999/xhtml">
  <block type="controls_if" inline="false" x="59" y="70">
    <value name="IF0">
      <block type="logic_compare" inline="true">
        <title name="OP">EQ</title>
        <value name="A">
          <block type="inout_digital_read">
            <title name="PIN">2</title>
          </block>
        </value>
        <value name="B">
          <block type="inout_highlow">
            <title name="BOOL">HIGH</title>
          </block>
        </value>
      </block>
    </value>
    <statement name="DO0">
      <block type="serial_print" inline="false">
        <value name="CONTENT">
          <block type="text">
            <title name="TEXT">Hello, World!</title>
          </block>
        </value>
      </block>
    </statement>
  </block>
</xml>
```

You can copy-paste code from BlocklyDuino’s Arduino tab into the Arduino IDE.

![BlocklyDuino Arduino Tab](/assets/img/arduino-blocklyduino-source.png)

You can then use [Arduino IDE](https://www.arduino.cc/en/main/software) to verify it, and upload.

![Arduino IDE with code copied from BlocklyDuino](/assets/img/arduino-ide-blocklyduino-source.png)

Toggle Pin 2 between 3.3 (Arduino Pro) or 5 volts and GND with a wire. You should see text appear in the serial port output when the pin is high.