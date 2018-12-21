---
layout: default
title: USB Serial
tags: usb serial macos linux
comments: true
---
# USB Serial

Serial port access can be very useful during embedded systems development.

I do most of my development on Mac OS X, or Ubuntu and Windows virtual machines. I use a USB to serial cable/breakout to connect a serial port to the Mac, which is then redirected by Parallels Desktop to the guest OS.

If you have a cable that uses the Prolific USB Serial chipset, getting up and running is well documented by [Plugable](http://plugable.com/2011/07/12/installing-a-usb-serial-adapter-on-mac-os-x). The driver they provide works for me. Most other cables use a chipset from FTDI, but Mac OS X already provides a driver for that.

To interact with a terminal on the embedded system you need some kind of [terminal emulator](http://en.wikipedia.org/wiki/List_of_terminal_emulators).

I use miniterm.py and screen on Ubuntu

```bash
miniterm.py -b 115200 /dev/ttyUSB0
```

Ensure that you have access to the device

```bash
sudo chmod 777 /dev/ttyUSB0
```

On Mac OS X I usually use screen

```bash
screen /dev/cu.usbserial 115200
```
