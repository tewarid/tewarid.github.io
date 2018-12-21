---
layout: default
title: VMware Fusion vs Parallels Desktop 8
tags: vmware fusion comparison parallels macos
comments: true
---
# VMware Fusion vs Parallels Desktop 8

I am migrating to a MacBook Pro at work. I do lots of development that requires Windows 8 and Ubuntu Linux. I could use a dual boot setup but switching can get cumbersome pretty quickly. I decided to adopt a virtual PC setup. I tried three contenders - Parallels Desktop 8, VirtualBox, and VMware Fusion. The most critical aspects for me are, being able to store all the files on the host, and reliable access to USB devices from the virtual machines.

## Shared folders

All device folders under /Volumes, and the Home folder, appear under /media on Ubuntu Linux (12.04) with Parallels. They appear as mapped drives on Windows 8, the Home folder appears as letter Z. Windows 8 Downloads folder is mapped to Downloads folder on the Mac. Virtual Box is somewhat simple, it maps folders you tell it to. In VMware, the Lubuntu appliance does not map any folders, I haven't been able to figure out why. I also couldn't get my hands on a Ubuntu appliance to test. Windows 8 does map the home folder as letter Z, but not the device folders under /Volumes.

## USB throughput

I tested USB performance while using the Saleae Logic Analyzer. That is the most timing sensitive USB device I need to use from the VM. With Parallels I was able to use a sample rate of up to 12 MHz, more than enough for my needs. In VMware it fails even with a 500 KHz sample rate. I get a 2 MHz sample rate in VirtualBox.

## USB reliability

Some things that work normally from the host, fail inexplicably in Parallels. JTAGICE mkII, a popular JTAG programmer from Atmel, didn't work on the Windows 8 VM until I updated to Atmel Studio 6.1, which installs a newer driver for the device. Android Open Source Project provides a usbboot tool for PandaBoard, that fails to load fastboot over PandaBoard's USB OTG port on Ubuntu. I also noticed a complete failure of USB ports on the host, after suspending (by closing the lid) and resuming a few times. I tried plugging in various devices and they refused to appear in System Information and the VMs.

I didn't test reliability of USB in VirtualBox and VMware since throughput was found to be lacking.

## Conclusion

Parallels seems a better choice for now. I am hoping future updates will make USB more reliable.
