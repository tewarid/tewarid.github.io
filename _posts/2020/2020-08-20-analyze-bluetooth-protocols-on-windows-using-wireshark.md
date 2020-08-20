---
layout: default
title: Analyze Bluetooth protocols on Windows using Wireshark
tags: windows wireshark bluetooth usb protocol analysis
comments: true
---
# Analyze Bluetooth protocols on Windows using Wireshark

Wireshark for Windows comes with the optional [USBPcap](https://github.com/desowin/usbpcap) package that can be used to capture USB traffic. Most computers with Bluetooth, internally use the USB bus, or you can use an off-the-shelf USB dongle. To capture USB traffic, start capture on the USBPcap1 interface or something similar. You can determine if any Bluetooth traffic has been captured, by entering `bluetooth` in the filter box. Other useful filter terms are `hci_usb`, `bthci_acl`, `btl2cap`, `btrfcomm`, and `btspp`.

![USBPcap](/assets/img/usbpcap-bluetooth.png)
