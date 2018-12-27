---
layout: default
title: Custom USB driver and app using WinUSB and C#
tags: winusb usb bulk c# .net programming
comments: true
---
# Custom USB driver and app using WinUSB and C#

Writing USB drivers used to be a tough proposition before [WinUSB](https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/winusb). There are other frameworks like the [WinDriver](https://www.jungo.com/st/products/windriver/) toolkit from Jungo that have existed before WinUSB, but they can easily cost several thousand dollars in developer licenses. You can target Windows XP SP3 and beyond with WinUSB. If you are new to USB I suggest reading Jack Ganssle's [USB Overview](http://www.ganssle.com/articles/usb.htm).

## Creating a Custom Driver

WinUSB has a kernel mode driver (winusb.sys) that talks with the device and a user mode DLL (winusb.dll) that communicates with the driver. To communication with the USB device Windows needs to know about your device. This configuration is provided in an INF file. I refer you to the [INF template](https://github.com/madwizard-thomas/winusbnet/wiki/INFTemplate) as a starting point. I am reproducing a modified version of the template that works with 32-bit and 64-bit Windows. Remember to change strings that have MY in them, and the class and device interface GUIDs. You'll also need to edit the USB vendor and product IDs to match your device.

```inf
[Version]
Signature = "$Windows NT$"
Class=MYCLASS
ClassGuid={1cccf8fe-33c2-4fec-9a7f-fa628fca0df9}
Provider = %ManufacturerName%
;CatalogFile=MyCatFile.cat
DriverVer=03/19/2012,1.0.0.0

[ClassInstall32]
AddReg=CustomClassAddReg

[CustomClassAddReg]
HKR,,,,%DisplayClassName%
HKR,,Icon,,-20

; ========== Manufacturer/Models sections ===========

[Manufacturer]
%ManufacturerName% = Standard,NTx86
%ManufacturerName% = Standard,NTamd64

[Standard.NTx86]
%DeviceName% =USB_Install, USB\VID_xxxx&PID_xxxx
%DeviceName% =USB_Install, USB\VID_xxxx&PID_xxxx

[Standard.NTamd64]
%DeviceName% =USB_Install, USB\VID_xxxx&PID_xxxx
%DeviceName% =USB_Install, USB\VID_xxxx&PID_xxxx

; =================== Installation ===================

[USB_Install]
Include=winusb.inf
Needs=WINUSB.NT

[USB_Install.Services]
Include=winusb.inf
AddService=WinUsb,0x00000002,WinUsb_ServiceInstall

[WinUsb_ServiceInstall]
DisplayName     = %WinUsb_SvcDesc%
ServiceType     = 1
StartType       = 3
ErrorControl    = 1
ServiceBinary   = %12%\WinUSB.sys

[USB_Install.Wdf]
KmdfService=WINUSB, WinUsb_Install

[WinUsb_Install]
KmdfLibraryVersion=1.9

[USB_Install.HW]
AddReg=Dev_AddReg

[Dev_AddReg]
HKR,,DeviceInterfaceGUIDs,0x10000,"{f167724d-228c-430e-86b5-f0368910eb22}"

[USB_Install.CoInstallers]
AddReg=CoInstallers_AddReg
CopyFiles=CoInstallers_CopyFiles

[CoInstallers_AddReg]
HKR,,CoInstallers32,0x00010000,"WdfCoInstaller01009.dll,WdfCoInstaller","WinUsbCoInstaller2.dll"

[CoInstallers_CopyFiles]
WinUsbCoInstaller2.dll
WdfCoInstaller01009.dll

[DestinationDirs]
CoInstallers_CopyFiles=11

; ================= Source Media Section =====================

[SourceDisksNames]
1 = %InstallDisk%,,,\x86
2 = %InstallDisk%,,,\amd64

[SourceDisksFiles.x86]
WinUSBCoInstaller2.dll=1
WdfCoInstaller01009.dll=1

[SourceDisksFiles.amd64]
WinUSBCoInstaller2.dll=2
WdfCoInstaller01009.dll=2

; =================== Strings ===================

[Strings]
ManufacturerName="MY COMPANY Inc"
ClassName="MY DEVICE NAME"
DiskName="USB Installation Disk"
WinUsb_SvcDesc="WinUSB Driver"
DeviceName="MY DEVICE NAME"
DisplayClassName="MY DEVICE NAME"
```

To understand how to put together a driver package I refer you to the [WinUSB (winusb.sys) Installation](https://github.com/madwizard-thomas/winusbnet/wiki/INFTemplate) MSDN document. You'll need the latest version of [Windows Driver Kit](https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk).

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

You can now use the Windows Device Manager to update the driver for your, as yet, unknown device.  Point Windows to the INF file you have created. If all goes well you'll see a MY DEVICE NAME device category with a device called MY DEVICE NAME, or something else appropriate if you've changed that in the INF file. Windows 8 refuses to install unsigned drivers, you'll either need to enable installation of unsigned drivers, or [test-sign](https://docs.microsoft.com/en-us/windows-hardware/drivers/install/how-to-test-sign-a-driver-package) the driver.

## Using WinUSB without a driver package

Your USB device may work with WinUSB without requiring a custom INF. Details are available under section _Installing WinUSB by specifying the system-provided device class_ at [WinUSB Installation](https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/winusb-installation). You'll need to edit Windows registry to set the device interface GUID each time the device is plugged to a different physical port.

## Communicate with the device in C# using WinUSBNet

We'll use the excellent [WinUSBNet](https://github.com/madwizard-thomas/winusbnet) component to communicate with the device. Download and reference it in your C# project. Here's a short snippet of code that demonstrates how you can use WinUSBNet to access your USB device.

```c#
static void Main(string[] args)
{
  USBDevice device =
  USBDevice.GetSingleDevice("{f167724d-228c-430e-86b5-f0368910eb22}");

  PrintInfo(device);

  USBInterface iface = device.Interfaces[1];

  iface.OutPipe.Write(new byte[] { 0x00, 0x03, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 });

  byte[] data = new byte[100];
  int len = iface.InPipe.Read(data);
  PrintHex(data, len);

  Console.ReadLine();
}

static void PrintInfo(USBDevice device)
{
  foreach (USBInterface iface in device.Interfaces)
  {
    Console.WriteLine("Interface - id:{0}, protocol:{1}, class:{2}, subclass:{3}",
      iface.Number, iface.Protocol, iface.ClassValue, iface.SubClass);
    foreach (USBPipe pipe in iface.Pipes)
    {
      Console.WriteLine("  Pipe - address:{0}", pipe.Address);
    }
  }
}

static void PrintHex(byte[] data, int length)
{
  for (int i = 0; i < length; i++)
  {
    Console.Write("{0:x2} ", data[i]);
  }
}
```

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
