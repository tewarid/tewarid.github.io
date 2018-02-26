---
layout: default
title: Sniff USB bus on Linux
tags: sniff usb bus linux wireshark
---

There are two ways.

### Using usbmon

Load the [usbmon](http://people.redhat.com/zaitcev/linux/OLS05_zaitcev.pdf) module

```bash
modprobe usbmon
```

The following command then prints data going to and fro on a bus

```bash
sudo cat /sys/kernel/debug/usb/usbmon/1u
```

### Using Wireshark

I refer you to their [USB wiki](http://wiki.wireshark.org/CaptureSetup/USB).
