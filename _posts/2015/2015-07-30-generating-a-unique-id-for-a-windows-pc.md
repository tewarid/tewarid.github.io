---
layout: default
title: Generating a unique ID for a Windows PC
tags: wmi windows unique licensing programming
comments: true
---

Software licensing usually works by tying a product to a single PC. Identifying the PC in a unique manner usually requires generating some kind of unique ID.

Here's a log of certain attributes of a Windows PC (a Parallels virtual machine) read using the Windows Management Instrumentation API of .NET. It was generated using the [WMI Query](https://github.com/tewarid/net-wmi-query) utility available at GitHub.

```conf
Win32_BaseBoard.Manufacturer="Parallels Software International Inc."
Win32_BaseBoard.Name="Base Board"
Win32_BaseBoard.SerialNumber="None"
Win32_BIOS.Manufacturer="Parallels Software International Inc."
Win32_BIOS.SMBIOSBIOSVersion="10.2.1 (29006) rev 0"
Win32_BIOS.SerialNumber="Parallels-FC C8 89 B7 D4 BF 4E 13 9D 53 D8 BC C1 9B 90 A8"
Win32_BIOS.ReleaseDate="20150520000000.000000+000"
Win32_BIOS.Version="PRLS   - 1"
Win32_Processor.ProcessorId="BFEBFBFF000306A9"
Win32_Processor.Name="Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz"
Win32_Processor.Manufacturer="GenuineIntel"
Win32_Processor.MaxClockSpeed="2800"
Win32_OperatingSystem.Name="Microsoft Windows 8 Pro|C:\WINDOWS|\Device\Harddisk0\Partition2"
Win32_OperatingSystem.OSArchitecture="64-bit"
Win32_OperatingSystem.SerialNumber="00330-80000-00000-AA279"
```

The challenge in generating a unique ID is deciding which information to use. The ID itself can be generated [fairly easily](http://www.codeproject.com/Articles/28678/Generating-Unique-Key-Finger-Print-for-a-Computer) by hashing the information using a cryptographic hash function.

Use too much of the information above and you risk the ID changing frequently. Updating Parallels may result in changes to Win32_BIOS.SMBIOSBIOSVersion and Win32_BIOS.ReleaseDate. Upgrading Windows may result in changes to Win32_OperatingSystem.Name, Win32_OperatingSystem.OSArchitecture, and Win32_OperatingSystem.SerialNumber.

I've found Win32_BIOS.SerialNumber and Win32_Processor.ProcessorId to be fairly stable. They'll only change if the PC's motherboard is changed or its CPU. Not likely to happen that frequently with laptops.
