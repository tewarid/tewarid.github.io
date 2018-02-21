---
layout: default
title: Embedded Linux system for Raspberry Pi with Yocto Project
tags: yocto linux kernel raspberry pi
---

Yocto Project, and OpenEmbedded, have been making news lately as the toolchain to build custom embedded Linux systems. I decided to try and get a working Linux system up and running on a Raspberry Pi.

The procedure that follows uses the [meta-raspberrypi](https://github.com/agherzan/meta-raspberrypi) BSP in tandem with Yocto Project poky.

Initialize the build by executing the following commands. I use an Ubuntu 14.04 VM with Parallels.

```bash
git clone http://git.yoctoproject.org/git/poky
git clone http://git.yoctoproject.org/git/meta-raspberrypi
git clone https://github.com/dv1/meta-gstreamer1.0.git
source poky/oe-init-build-env rpi-build
```

Append meta-raspberrypi and meta-gstreamer1.0 layers to BBLAYERS in `conf/bblayers.conf`.

For example

```conf
BBLAYERS ?= " \
  /home/parallels/yocto/poky/meta \
  /home/parallels/yocto/poky/meta-yocto \
  /home/parallels/yocto/poky/meta-yocto-bsp \
  /home/parallels/yocto/meta-gstreamer1.0 \
  /home/parallels/yocto/meta-raspberrypi \
  "
```

Set MACHINE to raspberrypi in `conf/local.conf`.

Complete the build by executing

```bash
bitbake rpi-hwup-image
```

That will take a while.

After the build is complete, create an SD card with the following command. Remember to change /dev/sdb to the proper device name.

```bash
dd if=tmp/deploy/images/raspberrypi/rpi-hwup-image-raspberrypi.rpi-sdimg of=/dev/sdb
```

Boot Pi using the SD card. Command line output appears on the HDMI display, or the serial port on the [expansion header]({% link _posts/2014/2014-07-21-sparkfun-ftdi-basic-with-raspberry-pi.md %}). Login is root, with an empty password.
