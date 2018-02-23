---
layout: default
title: Building usbboot
tags: usbboot usb boot pandaboard arm android aosp
---

I have mentioned usbboot in the post [Install AOSP build to PandaBoard]({% link _posts/2013/2013-05-29-install-aosp-build-to-pandaboard.md %}). In this post I show how you can tweak the usbboot utility and build it from [source](https://github.com/swetland/omap4boot). I am running Ubuntu 12.04 within Parallels on MacOS.

To begin, clone omap4boot from GitHub.

### Obtain toolchain

The build procedure requires the gcc cross-compiler for ARM. It can be obtained as follows

```bash
sudo apt-get install gcc-arm-linux-gnueabi
```

### Build

Execute make

```bash
TOOLCHAIN=arm-linux-gnueabi- make
```

I had to [patch](https://github.com/oblique/omap4boot/commit/a58a6ed43391693427e208402d0770f9a166e2ef) the Makefile to avoid the following error

```text
trusted.S:10: Error: selected processor does not support ARM mode `smc 1'
```

### Execute

It is rather straightforward to execute the newly baked usbboot. Here's how you can use it in place of the binary that ships with AOSP

```bash
sudo <omap4boot folder>/out/panda/usbboot <aosp folder>/device/ti/panda/bootloader.bin
```

Unfortunately, still does not work with PandaBoard Rev A2.

### Debug using serial port

The second stage loader that usbboot sends to PandaBoard writes some useful debug information to the serial port. You can view that information using a terminal emulator on Ubuntu

```bash
miniterm.py -b 115200 /dev/ttyUSB0
```
