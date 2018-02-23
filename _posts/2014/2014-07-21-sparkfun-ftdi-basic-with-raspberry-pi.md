---
layout: default
title: SparkFun FTDI Basic with Raspberry Pi
tags: sparkfun make ftdi pi raspberry
---

The following diagram shows how you can connect an [FTDI Basic](https://www.sparkfun.com/products/9873) (USB to serial) breakout board to Raspberry Pi's GPIO connector. If you've configured VCC to output 5 Volts, you can also power the Raspberry Pi by connecting its 5V header pin to VCC.

![pi-ftdi-basic](/assets/img/fritzing-pi-ftdi-basic.png)

If you've got Adafruit's [USB to Serial TTL cable](https://www.adafruit.com/products/954), you can follow their [lesson](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable) on using it.

### Output kernel log to console

For the kernel log to appear on the serial port, console should be set to ttyAMA0.

Here's how cmdline.txt in the boot partition of my Raspberry Pi looks like

```conf
dwc_otg.fiq_fix_enable=1 sdhci-bcm2708.sync_after_dma=0 dwc_otg.lpm_enable=0 console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootwait
```

To get a login prompt /etc/inittab should contain a line such as

```conf
ttyAMA0::respawn:/sbin/getty -L ttyAMA0 115200 vt100 # GENERIC_SERIAL
```

If you're compiling your own kernel using Buildroot, set the TTY port to ttyAMA0 under System configuration, getty options

![ttyAMA0](/assets/img/buildroot-system-configuration-tty.png)
