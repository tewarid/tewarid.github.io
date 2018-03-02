---
layout: default
title: USB Descriptors of Arduino UNO
tags: usb arduino uno hardware
---

I've been studying the USB interface of [Arduino UNO](https://www.adafruit.com/products/50) so that I can interface it to an embedded host. It appears as a serial port on Linux, macOS, and Windows 10, without need for custom drivers. The Arduino IDE can reprogram the device over the serial port. Makers also use it to output debug information.

![uno.png](/assets/img/fritzing-arduino-uno.png)

Here's the detailed device descriptor as seen on Linux with `lsusb -v`

```text
Bus 001 Device 005: ID 2341:0043 Arduino SA Uno R3 (CDC ACM)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            2 Communications
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x2341 Arduino SA
  idProduct          0x0043 Uno R3 (CDC ACM)
  bcdDevice            0.01
  iManufacturer           1
  iProduct                2
  iSerial               220
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           62
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               10.01
      CDC ACM:
        bmCapabilities       0x06
          sends break
          line coding and serial state
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval             255
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
```

Interface descriptor with class Data Interface Class i.e. `bInterfaceClass=0x0A`, is used for serial communications. Endpoint with `bEndpointAddress` `0x03` is used for input, and `bEndpointAddress` `0x04` for output.
