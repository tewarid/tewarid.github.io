---
layout: default
title: View USB device descriptors on Windows
tags: usb descriptor windows
comments: true
---
# View USB device descriptors on Windows

I have occasionally fired up a Linux virtual machine just to view USB descriptors of devices using `lsusb -v`. This post briefly describes a couple of tools for Windows that can be used to view descriptors of USB devices.

## Thesycon USB Descriptor Dumper

This single purpose utility, [from](http://www.thesycon.de/eng/usb_descriptordumper.shtml) a German device driver development company, does what it proposes. It lists all connected USB devices and dumps the information for the selected device.

![Thesycon USB Descriptor Dumper](/assets/img/usb-dd-thesycon.png)

## USBView

This tool is part of the [Windows Driver Kit](https://developer.microsoft.com/windows/hardware/windows-driver-kit) (WDK) and [Debugging Tools for Windows](https://msdn.microsoft.com/en-us/library/windows/hardware/ff551063.aspx). Its [source code](https://github.com/Microsoft/Windows-driver-samples/tree/master/usb/usbview) is available as part of the [Windows driver samples](https://github.com/Microsoft/Windows-driver-samples) GitHub repo.

![USBView Utility](/assets/img/usb-dd-usbview.png)
