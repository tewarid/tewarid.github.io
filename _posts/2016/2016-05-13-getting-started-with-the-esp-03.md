---
layout: default
title: Getting Started with the ESP-03
tags: esp8266 esp-03 esp03 arduino adafruit wi-fi wifi
---

The [ESP-03](http://www.electrodragon.com/product/esp8266-wifi-board-full-ios-smd/) is a very affordable Wi-Fi module built around the ESP8266EX chip by [Espressif](http://espressif.com/). The ESP8266 has become very popular among makers who want to add wireless smarts to things at home and work.

The ESP-03 has two useful modes of operation that can be initiated by controlling its [GPIO](http://www.esp8266.com/wiki/doku.php?id=esp8266-module-family#esp-03) pins - normal mode and flash mode.

Normal mode wiring is show in the figure below. ESP-03 shown here is powered using SparkFun's [FTDI Basic Breakout](https://www.sparkfun.com/products/9873) - 3.3V - USB to serial module.

![Normal Mode](/assets/img/fritzing-esp03-normal-mode.png)

In this mode, ESP-03 executes firmware programmed to the SPI Flash. SPI Flash is an external NOR Flash chip where program instructions are stored, and retrieved during execution.

The ESP-03 has a 4 Mbit 25Q40BT part which allows for 512 KB of program space. Of that, about 423 KB is available for your own programs.

![Serial Flash Chip](/assets/img/esp03-serial-flash.jpg)

In flash mode, new program instructions can be flashed to SPI Flash, using tools such as the [ESP Flash Download Tool](https://espressif.com/en/support/download/other-tools). The wiring is similar to that for normal mode, with the addition of GPIO0 connected to GND.

![Flash Mode](/assets/img/fritzing-esp03-flash-mode.png)

ESP8266 can be programmed using an [SDK](http://espressif.com/en/products/hardware/esp8266ex/resources) distributed by Espressif. Popular embedded development platforms such as the [Arduino IDE](https://www.arduino.cc/en/main/software), MicroPython, and [Lua](http://nodemcu.com) can also be used.

Adafruit provides [instructions](https://learn.adafruit.com/adafruit-huzzah-esp8266-breakout/using-arduino-ide) for configuring the Arduino IDE for ESP8266 development. Here're the settings I use with the Arduino IDE - under Tools menu.

![Arduino Settings](/assets/img/esp03-arduino-ide-settings.jpg)

Try the example project under File -> Examples -> ESP8266WiFi. With it, you'll be controlling a GPIO pin on the ESP-03, over your Wi-Fi network, in no time at all.

![Wi-Fi Web Server](/assets/img/esp03-wifi-web-server.gif)
