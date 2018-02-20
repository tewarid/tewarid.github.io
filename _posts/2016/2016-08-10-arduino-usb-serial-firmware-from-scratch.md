---
layout: default
title: Arduino USB Serial firmware from scratch
tags: arduino usb serial hardware programming atmega16u2
---

I have need to change the USB descriptors of an Arduino Uno R3 acting as a peripheral to another device. This post describes how I built a [USB Serial firmware](https://github.com/tewarid/arduino-usb-serial) for the ATmega16U2 on an Arduino Uno R3, using Atmel Studio 7 and its LUFA Library extension. It can be flashed using the built-in DFU firmware and Atmel's [FLIP](http://www.microchip.com/developmenttools/productdetails.aspx?partno=flip) tool.

Source files that perform the actual USB/serial proxying are derived from USB to Serial Converter example project for the at90usb1287 (File -> New -> Example Project...). I suggest creating a project based on that example and copying the files over. I have also borrowed code from the official [source code](https://github.com/arduino/Arduino/tree/master/hardware/arduino/avr/firmwares/atmegaxxu2/arduino-usbserial) at GitHub to enable additional functionality such as allowing a sketch to be uploaded from the Arduino IDE.

![USB to Serial Converter Example Project](/assets/img/atmel-studio-usb-serial-converter.png)

Install LUFA Library extension if not already installed (Tools -> Extensions and Updates...)

![Install LUFA Extension](/assets/img/atmel-studio-install-lufa.png)

Create a new project for the ATmega16U2 (File -> New -> Project...)

![New Atmel Studio Board Project](/assets/img/atmel-studio-new-asf-board-project.png)

![Board Selection](/assets/img/atmel-studio-board-atmega16u2.png)

Use ASF Wizard (ASF -> ASF Wizard) to add LUFA modules and remove the Generic board support (driver) module.

![ASF Wizard](/assets/img/atmel-studio-asf-wizard-lufa.png)

Configure GCC symbols (Project -> Properties). Change `BOARD` to `BOARD_UNO`, and add `F_CPU=16000000UL` and `F_USB=16000000UL`.

![GCC symbols](/assets/img/atmel-studio-symbols-usb-serial.png)

Copy over source files from the example project mentioned earlier. Resolve any build errors.

Flash (Tools -> Device Programming) the firmware using the FLIP tool

![Flash using FLIP](/assets/img/atmel-flip-usb-serial.png)

Reboot the Arduino.
