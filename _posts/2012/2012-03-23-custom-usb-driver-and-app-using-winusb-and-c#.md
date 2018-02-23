---
layout: default
title: Custom USB driver and app using WinUSB and C#
tags: winusb usb bulk c# .net programming
---

Writing USB drivers used to be a tough proposition before [WinUSB](http://msdn.microsoft.com/en-us/library/ff540196.aspx). There are other frameworks like the [WinDriver](http://www.jungo.com/st/windriver_usb_pci_driver_development_software.html) toolkit from Jungo that have existed before WinUSB, but they can easily cost several thousand dollars in developer licenses. You can target Windows XP SP3 and beyond with WinUSB. If you are new to USB I suggest reading Jack Ganssle's [USB Overview](http://www.ganssle.com/articles/usb.htm).

### Creating a Custom Driver

WinUSB has a kernel mode driver (winusb.sys) that talks with the device and a user mode DLL (winusb.dll) that communicates with the driver. To communication with the USB device Windows needs to know about your device. This configuration is provided in an INF file. I refer you to the [INF template](http://code.google.com/p/winusbnet/wiki/INFTemplate) as a starting point. I am reproducing a modified version of the template that works with 32-bit and 64-bit Windows. Remember to change strings that have MY in them, and the class and device interface GUIDs. You'll also need to edit the USB vendor and product IDs to match your device.

{% gist 22c77cfa9965d277e6ae8bbd030b73af %}

To understand how to put together a driver package I refer you to the [WinUSB (winusb.sys) Installation](http://msdn.microsoft.com/en-us/library/ff540283.aspx) MSDN document. You'll need the latest version of [Windows Driver Kit](http://msdn.microsoft.com/en-us/windows/hardware/gg487428).

Your objective then is to have a folder with the following elements.

```text
<root folder>
  <device>.inf
  x86
    WdfCoInstaller01009.dll
    winusbcoinstaller2.dll
  amd64
    WdfCoInstaller01009.dll
    winusbcoinstaller2.dll
```

You can now use the Windows Device Manager to update the driver for your, as yet, unknown device.  Point Windows to the INF file you have created. If all goes well you'll see a MY DEVICE NAME device category with a device called MY DEVICE NAME, or something else appropriate if you've changed that in the INF file. Windows 8 refuses to install unsigned drivers, you'll either need to [enable](http://www.windows7hacker.com/index.php/2012/08/how-to-install-an-un-signed-3rd-party-driver-in-windows-8/) installation of unsigned drivers, or [test-sign](http://msdn.microsoft.com/en-us/library/windows/hardware/ff546236.aspx) the driver.

### Using WinUSB without a driver package

Your USB device may work with WinUSB without requiring a custom INF. Details are available under section "Installing WinUSB by specifying the system-provided device class" at [WinUSB Installation](http://msdn.microsoft.com/en-us/library/windows/hardware/ff540283.aspx). You'll need to edit Windows registry to set the device interface GUID each time the device is plugged to a different physical port. If your device provides the [right descriptors](http://msdn.microsoft.com/en-us/library/windows/hardware/hh450799.aspx) it should work with Windows 8 without requiring any extra effort.

### Communicate with the device in C# using WinUSBNet

We'll use the excellent [WinUSBNet](https://github.com/madwizard-thomas/winusbnet) component to communicate with the device. Download and reference it in your C# project. Here's a short snippet of code that demonstrates how you can use WinUSBNet to access your USB device.

{% gist 89f0f1a9a097c075df8c9cb51954b390 %}

Here's some sample output produced by running the console app above. The information regarding the USB Device is printed using the printInfo method.

```text
Interface - id:0, protocol:1, class:2, subclass:2
  Pipe - address:129
Interface - id:1, protocol:0, class:10, subclass:0
  Pipe - address:3
  Pipe - address:130
00 02 00 00 00 00 00 06 00 00 00 07 00 00 00 02 01 01 01
```

The most significant bit of the pipe's address indicates direction, it is IN (data arriving at the host) when set. Thus address 129 (0x81) is actually a bulk data IN endpoint with ID 1. WinUSBNet only supports control and bulk transfer endpoints.
