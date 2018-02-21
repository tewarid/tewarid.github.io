---
layout: default
title: USB CDC ACM driver for Windows
tags: usb cdc acm windows driver
---

The [LUFA](https://github.com/abcminiuser/lufa) library provides a template INF file that can be easily extended to create a serial port driver for your USB CDC ACM device. Here's the template with CatalogFile added by me

```ini
;     Windows LUFA CDC ACM Setup File
; Copyright (c) 2000 Microsoft Corporation

[DefaultInstall]
CopyINF="LUFA CDC-ACM.inf"

[Version]
Signature="$Windows NT$"
Class=Ports
ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
Provider=%MFGNAME%
CatalogFile="LUFA CDC-ACM.cat"
DriverVer=07/01/2012,10.0.0.0

[Manufacturer]
%MFGNAME%=DeviceList, NTx86, NTamd64, NTia64

[SourceDisksNames]

[SourceDisksFiles]

[DestinationDirs]
DefaultDestDir=12

[DriverInstall]
Include=mdmcpq.inf
CopyFiles=FakeModemCopyFileSection
AddReg=DriverInstall.AddReg

[DriverInstall.Services]
Include=mdmcpq.inf
AddService=usbser, 0x00000002, LowerFilter_Service_Inst

[DriverInstall.AddReg]
HKR,,EnumPropPages32,,"msports.dll,SerialPortPropPageProvider"

;------------------------------------------------------------------------------
;  Vendor and Product ID Definitions
;------------------------------------------------------------------------------
; When developing your USB device, the VID and PID used in the PC side
; application program and the firmware on the microcontroller must match.
; Modify the below line to use your VID and PID.  Use the format as shown below.
; Note: One INF file can be used for multiple devices with different VID and PIDs.
; For each supported device, append ",USB\VID_xxxx&PID_yyyy" to the end of the line.
;------------------------------------------------------------------------------
[DeviceList]
%DESCRIPTION%=DriverInstall, USB\VID_03EB&PID_2044

[DeviceList.NTx86]
%DESCRIPTION%=DriverInstall, USB\VID_03EB&PID_2044

[DeviceList.NTamd64]
%DESCRIPTION%=DriverInstall, USB\VID_03EB&PID_2044

[DeviceList.NTia64]
%DESCRIPTION%=DriverInstall, USB\VID_03EB&PID_2044

;------------------------------------------------------------------------------
;  String Definitions
;------------------------------------------------------------------------------
;Modify these strings to customize your device
;------------------------------------------------------------------------------
[Strings]
MFGNAME="http://www.lufa-lib.org"
DESCRIPTION="LUFA CDC-ACM Virtual Serial Port"
```

Replace `VID_03EB&PID_2044` with something appropriate for your device.

To use this on Windows 8.1 without disabling signed driver check, you'll need to self-sign the driver. Install Windows Driver Kit (WDK) 8.1 and execute the following from a privileged command prompt

```cmd
makecert.exe -r -pe -ss PrivateCertStore -n CN=Test.org(Test) Test.cer

Inf2cat.exe /driver:. /os:7_x64,7_X86 

Signtool.exe sign /v /s PrivateCertStore /n Test.org(Test) /t http://timestamp.verisign.com/scripts/timstamp.dll "LUFA CDC-ACM.cat"

certmgr.exe /add Test.cer /s /r localMachine root
```

Note that in Windows Driver Kit 7.1 Signtool.exe is located under `bin\selfsign`, and in Windows Driver Kit 8.1 it is located under `bin\x86`.

Now, you should be able to manually install the driver by pointing Windows 8.1 to the folder containing the INF and cat files.
