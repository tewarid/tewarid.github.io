---
layout: default
title: Arduino USB DFU firmware from scratch
tags: arduino usb dfu avr atmel studio
comments: true
---

The Device Firmware Upgrade (DFU) firmware for the ATmega16U2 on Arduino Uno R3 is used to flash the USB Serial firmware, among [others](https://www.arduino.cc/en/Hacking/MidiWith8U2Firmware), using Atmel's [FLIP](http://www.microchip.com/developmenttools/productdetails.aspx?partno=flip) tool.

This post documents how you can build from scratch DFU firmware using Atmel Studio 7 and its LUFA Library extension. You'll need an ISP/ICSP programmer to program the ATmega16U2.

You can install the LUFA extension from the Extensions and Updates dialog (Tools -> Extensions and Updates).

![Install LUFA Extension](/assets/img/atmel-studio-install-lufa.png)

Create a new project based on the DFU Bootloader example (File -> New -> Example Project...).

![DFU LUFA Example in Atmel Studio](/assets/img/atmel-studio-dfu-lufa-example.png)

Change the compiler optimization setting to -Os in toolchain properties (Project -> Properties).

![Optimize for Size Configuration](/assets/img/atmel-studio-optimize-for-size-dfu.png)

Build the solution and flash (Tools -> Device Programming) using an [ISP/ICSP programmer]({% link _posts/2016/2016-08-05-arduino-uno-bootloader-programming-using-jtagice-mkii.md %}) connected to the ICSP2 header.

![Device Programming](/assets/img/atmel-studio-device-programming-dfu.png)
