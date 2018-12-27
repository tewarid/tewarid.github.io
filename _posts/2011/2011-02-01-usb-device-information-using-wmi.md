---
layout: default
title: USB device information using WMI
tags: wmi windows usb
comments: true
---
# USB device information using WMI

The System.Management namespace of the .NET framework has some Windows-specific features for recovering information regarding a USB device. The following list of [Windows Management Instrumentation](http://technet.microsoft.com/en-us/library/ee692772.aspx) (WMI) classes are enough to recover almost all information one could need regarding the device.

* [`Win32_PnPEntity`](https://docs.microsoft.com/en-us/windows/desktop/CIMWin32Prov/win32-pnpentity)

  Information regarding vendor and product IDs, device name etc

* [`Win32_SystemDriver`](https://docs.microsoft.com/en-us/windows/desktop/CIMWin32Prov/win32-systemdriver)

  Information regarding the driver itself such as driver file name and path

* [`Win32_PnPSignedDriver`](https://msdn.microsoft.com/en-us/library/aa394354.aspx)

  Information regarding the driver inf file and more

The `FriendlyName` attribute is common to all of these classes and can be used to filter for a specific device. 

This is how one can query for a specific USB device if you have a product and vendor ID for it

```c#
  ManagementObjectSearcher searcher = new ManagementObjectSearcher(
    "SELECT PNPDeviceID, Name, Service FROM Win32_PnPEntity WHERE PNPDeviceID LIKE "
    + "'%VID[_]xxxx&PID[_]xxxx%'");

  foreach (ManagementObject entity in searcher.Get())
  {
    // do something useful
  }
```

The Service field can be used to determine which system driver is being used, or filter results based on it.

These are some values the field can assume

* BthPan

  Bluetooth PAN (personal area network) profile device.

* usb_rndisx

  USB RNDIS device.

_Kudos to Emerson de Lira Espinola for helping out with this._
