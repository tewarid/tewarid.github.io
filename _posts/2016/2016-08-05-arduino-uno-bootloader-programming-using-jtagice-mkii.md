---
layout: default
title: Arduino Uno bootloader programming using JTAGICE mkII
tags: arduino uno avr bootloader jtag
---

Arduino Uno comes with an ATmega328 microcontroller. Like all AVR MCUs it can be programmed using an [in-system programming](http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591739) interface (ISP or ICSP). This can be useful to upgrade the [bootloader](https://www.arduino.cc/en/Hacking/Bootloader), or to completely replace it and use the full program space on the MCU.

I have a [JTAGICE mkII](http://www.microchip.com/developmenttools/productdetails.aspx?partno=atjtagice2) at work that I use to program AVR32 MCUs. It supports programming the Arduino Uno using the wiring shown below.

![Arduino Uno ICSP headers](/assets/img/fritzing-arduino-uno-icsp.png)

The ATmega16U2 that drives the USB to serial interface - within orange rectangle in the figure above - can also be reprogrammed using the ICSP2 header.

The Arduino can also be programmed using the more affordable [JTAGICE3](http://www.microchip.com/developmenttools/productdetails.aspx?partno=atjtagice3).
