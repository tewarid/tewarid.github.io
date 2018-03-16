---
layout: default
title: Enable support for RNDIS Ethernet devices in the Linux kernel
tags: rndis linux kernel buildroot
comments: true
---

Use `make menuconfig` - or `linux-menuconfig` when using Buildroot - to invoke the kernel configuration wizard.

Then, enable the following modules under Device Drivers, Network device support, USB Network Adapters

* Multi-purpose USB Networking Framework
* CDC Ethernet support
* Host for RNDIS and ActiveSync devices

![Host for RNDIS and ActiveSync devices](/assets/img/buildroot-kernel-driver-rndis.png)

If the device you're using provides an IP address using DHCP, there's a [bug](https://patchwork.kernel.org/patch/693971/) in some Linux kernel versions that hinders obtaining an IP address from the device. You might want to patch or upgrade the kernel.
