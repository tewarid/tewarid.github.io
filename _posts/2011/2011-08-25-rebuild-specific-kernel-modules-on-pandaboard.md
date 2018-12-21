---
layout: default
title: Rebuild specific kernel modules on PandaBoard
tags: kernel build usbnet pandaboard linux
comments: true
---
# Rebuild specific kernel modules on PandaBoard

This procedure rebuilds the kernel modules for usb networking, to fix a regression in the usbnet driver reported [here](https://patchwork.kernel.org/patch/693971/), but the same procedure can be applied to other modules as well.

## Environment

I am running Ubuntu 11.04 preinstalled netbook image for [OMAP4](https://wiki.ubuntu.com/ARM/OMAP).

## Obtain Kernel Source

[Download](https://launchpad.net/ubuntu/natty/i386/linux-source-2.6.38/2.6.38-11.48) debian package from launchpad. I could not `apt-get` it for some reason. So I installed the deb package using

```bash
sudo dpkg -i linux-source-2.6.38_2.6.38-11.48_all.deb
```

## Extract kernel source

After installation, the compressed kernel source is available at `/usr/src/linux-source-2.6.38`. You can extract the kernel source to your home folder like this

```bash
tar xjf /usr/src/linux-source-2.6.38/linux-source-2.6.38.tar.bz2
```

## Obtain Kernel Headers

You may already have the kernel headers installed, otherwise

```bash
sudo apt-get linux-headers-omap4
```

## Rebuild module

Head over to the folder of the module

```bash
cd ~/linux-source-2.6.38/drivers/net/usb
```

Rebuild using `make`

```bash
make -C /usr/src/linux-headers-2.6.38-1208-omap4 M=`pwd`
```

## Replace modules

Backup existing module objects in case something goes wrong. Replace them

```bash
sudo cp *.ko /lib/modules/2.6.38-1208-omap4/kernel/drivers/net/usb/
```

Check if a module is already loaded

```bash
lsmod
```

and remove it

```bash
rmmod cdc_ether
```

Do something like plugging in the hardware so that the new module gets loaded.

That's all.

_With some inspiration from [here](https://ubuntuforums.org/showthread.php?t=1153067)._
