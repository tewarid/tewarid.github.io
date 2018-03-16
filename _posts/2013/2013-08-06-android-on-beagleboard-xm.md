---
layout: default
title: Android on BeagleBoard-xM
tags: android beagleboard xm ti
comments: true
---

I just crossed paths with a BeagleBoard-xM and thought I'd try Android on it. I tried pre-built binary images for Android 4.0.3 from Texas Instruments (TI), and Android 4.1.1 Jelly Bean image from project [rowboat](https://code.google.com/archive/p/rowboat/).

### Introduction

[Beagle](http://beagleboard.org/) is a set of embedded development boards that can run Android. The original BeagleBoard uses an OMAP 3 processor, specifically OMAP3530 with an ARM Cortex-A8 core running at 720 MHz. The BeagleBoard-xM uses the TI Sitara AM37x running at 1 GHz. I have Rev C of that board. The BeagleBone and BeagleBone Black use the TI Sitara AM335x.

### Android 4.0.3 (Ice Cream Sandwich)

I downloaded the pre-built [binary image](http://software-dl.ti.com/dsps/dsps_public_sw/sdo_tii/TI_Android_DevKit/TI_Android_ICS_4_0_3_DevKit_3_0_0/exports/beagleboardXM.tar.gz), a part of [TI Android Developer Kit](http://software-dl.ti.com/dsps/dsps_public_sw/sdo_tii/TI_Android_DevKit/TI_Android_ICS_4_0_3_DevKit_3_0_0/index_FDS.html).

Next, I used an Ubuntu 12.04 VM running in Parallels on a MacBook, and a MicroUSB USB adaptor, to write the binary image to a MicroSD card. The binary image includes a bash script that does the job

```bash
sudo ./mkmmc-android.sh /dev/sdb
```

Change `/dev/sdb` to whatever device appears in `dmesg | tail` after you plug in the MicroSD card.

Some cursory findings follow

1. Graphics acceleration looks good. Sample video in Gallery app plays well, but without any sound from audio out jack.
2. Ethernet interface seems to be supported as device usb0, didn't test it though.
3. The Gallery app has some nice images, and the slideshow option shows images with the Ken Burns effect.
4. adb with USB OTG connector does not seem to work. In fact the board does not appear on my MacBook.

### Android 4.1.1 (Jelly Bean)

The pre-built [binary](https://code.google.com/p/rowboat/downloads/detail?name=beagleboard-xm-jb.tar.gz&can=2&q=) for Jelly Bean is available from [rowboat](https://code.google.com/p/rowboat/downloads/list).

Findings are similar to the ones above. Surprisingly there is no Ethernet configuration under settings, so Ethernet needs to be started from the serial port shell

```bash
screen /dev/cu.usbserial 115200
netcfg usb0 up
```

It may probably work automatically if the ethernet cable is plugged in before the board boots up.

### BeagleBone and BeagleBone Black

Pre-built Jelly Bean images for BeagleBone are available from [TI](http://software-dl.ti.com/dsps/dsps_public_sw/sdo_tii/TI_Android_DevKit/TI_Android_JB_4_1_2_DevKit_4_0_1/index_FDS.html) and [rowboat](https://code.google.com/p/rowboat/downloads/detail?name=beaglebone-jb.tar.gz&can=2&q=). There are no pre-built images for BeagleBone Black yet.
