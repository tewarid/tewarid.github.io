---
layout: default
title: Use the Motorola Symbol CS3070 barcode scanner on a PC
tags: bluetooth symbol cs3070 scanner pc windows pair
comments: true
---

This post shows the different means to read scanned barcodes using a CS3070 barcode scanner, on a Windows 7 PC. These instructions may also serve as breadcrumbs for Windows XP and other operating systems.

We recommend downloading and printing the [CS3000 Series Quick Reference Guide](http://www.google.com/search?ix=seb&sourceid=chrome&ie=UTF-8&q=CS3000+Series+Quick+Reference+Guide) (QRG). It has some barcodes we'll need in the procedures below.

### Using the Bluetooth Serial Port Profile (SPP)

Follow these steps so that the barcode scanner can be read over a Serial (COM) Port:

1. Turn on the scanner by pressing the + button.
2. Scan the barcode for SPP from the QRG (page 10).
3. The scanner should be in Bluetooth discoverable mode. If you delayed a while and it is not discoverable, press the Bluetooth (Motorola logo) button for 5 seconds till it starts to blink rapidly.
4. On PC, in the Bluetooth control panel applet choose Add a Device (Windows 7). Choose device with name starting with CS3070.
5. Choose the option to provide a pairing code and enter 1234.
6. PC should pair with the scanner, the scanner will emit a beep and the blue LED (Bluetooth button) will start blinking less rapidly. PC will and add a COM port, you can obtain the port number in Device Manager.
7. Use a serial port terminal (like [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) or [teraterm](http://ttssh2.sourceforge.jp/)) to read data from the serial port, set the baud rate to 9600.

### Pair as a Bluetooth Keyboard (HID)

Follow these steps to add to a PC as a Bluetooth Keyboard (aka HID - Human Interface Device):

1. Turn on the scanner by pressing the + button.
2. Scan the barcode for Bluetooth Keyboard Emulation (HID) from the QRG.
3. The scanner should be in Bluetooth discoverable mode. If you delayed a while and it is not discoverable, press the Bluetooth (Motorola logo) button for 5 seconds till it starts to blink rapidly.
4. On PC, in the Bluetooth control panel applet choose Add a Device (Windows 7). Choose device with name starting with CS3070.
5. Allow the PC to generate a pairing code.
6. Scan the individual numbers of the pairing code using the Bluetooth scanner. Use the number barcodes in the QRG.
7. Scan the barcode for Enter.
8. PC should pair with the device and add a HID (keyboard).
9. Test the scanner works by opening Notepad and scanning a barcode.
