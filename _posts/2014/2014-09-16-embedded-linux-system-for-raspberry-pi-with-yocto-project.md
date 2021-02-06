---
layout: default
title: Embedded Linux system for Raspberry Pi with Yocto Project
tags: yocto linux kernel raspberry pi
comments: true
---
# Embedded Linux system for Raspberry Pi with Yocto Project

Yocto Project, and OpenEmbedded, have been making news lately as the toolchain to build custom embedded Linux systems. I decided to try and get a working Linux system up and running on a Raspberry Pi 1 Model B+.

The procedure that follows uses the [meta-raspberrypi](https://github.com/agherzan/meta-raspberrypi) BSP in tandem with Yocto Project poky, on a Ubuntu 20.04 host.

Download the required layers using git

```bash
git clone http://git.yoctoproject.org/git/poky
git clone http://git.yoctoproject.org/git/meta-raspberrypi
git clone https://github.com/dv1/meta-gstreamer1.0.git
```

Initialize the build environment by executing

```bash
source poky/oe-init-build-env rpi-build
```

You can run the same command again if you ever need to setup the environment again in the future.

Append `meta-raspberrypi` and any other layers to `BBLAYERS` in `conf/bblayers.conf`

```bash
vi conf/bblayers.conf
```

After you're done, `conf/bblayers.conf` should look like

```conf
BBLAYERS ?= " \
  /home/yoctopi/poky/meta \
  /home/yoctopi/poky/meta-poky \
  /home/yoctopi/poky/meta-yocto-bsp \
  /home/yoctopi/meta-gstreamer1.0 \
  /home/yoctopi/meta-raspberrypi \
  "
```

Set MACHINE to `raspberrypi` in `conf/local.conf`

```bash
vi conf/local.conf
```

After you're done, the relevant portion of `conf/local.conf` should look like

```conf
#MACHINE ?= "genericx86-64"
#MACHINE ?= "edgerouter"
#
# This sets the default machine to be qemux86-64 if no other machine is selected:
MACHINE ??= "raspberrypi"

#
# Where to place downloads
```

This will build an image suitable to be installed on a Raspberry 1 Model B+. Other available alternatives can be seen under `/workdir/meta-raspberrypi/conf/machine/`

```text
raspberrypi-cm.conf
raspberrypi-cm3.conf
raspberrypi.conf
raspberrypi0-wifi.conf
raspberrypi0.conf
raspberrypi2.conf
raspberrypi3-64.conf
raspberrypi3.conf
raspberrypi4-64.conf
raspberrypi4.conf
```

Complete the build by executing

```bash
bitbake core-image-base
```

That should take a while.

After the build is complete, create an SD card using the following commands

```bash
sudo apt install bmap-tools
sudo bmaptool copy --bmap tmp/deploy/images/raspberrypi/core-image-base-raspberrypi-20210115193541.rootfs.wic.bmap tmp/deploy/images/raspberrypi/core-image-base-raspberrypi-20210115193541.rootfs.wic.bz2 /dev/sda
```

Change `/dev/sda` to the appropriate device on your system.

Boot your Raspberry Pi using the SD card. Command line appears on the HDMI display, or, if configured, [over the serial port on the expansion header]({% link _posts/2014/2014-07-21-sparkfun-ftdi-basic-with-raspberry-pi.md %}). You can login as `root` with an empty password.
