---
layout: default
title: Embedded Linux system for Raspberry Pi with Buildroot
tags: buildroot linux build kernel programming
---

This post shows how easy it is to make a custom embedded Linux system for Raspberry Pi using Buildroot. I used an Ubuntu 13.04 VM for Parallels Desktop 9 to perform the build.

The Ubuntu VM required only a few dependencies and I could go ahead with the build. These I installed by executing

```bash
sudo apt-get install ncurses-dev git g++
```

I then obtained Buildroot release buildroot-2014.05.tar.gz and extracted it to a local folder using `tar xvzf buildroot-2014.05.tar.gz`. The procedure to perform the build and prepare an SD card is well documented in file `board/raspberrypi/readme.txt`.

I headed into the buildroot-2014.05 folder and prepared the appropriate `.config` file required by buildroot

```bash
cd buildroot-2014.05
make raspberrypi_defconfig
```

Since I wanted to generate a persistent root file system, I followed that by executing

```bash
make
```

The build takes a while to finish. Once done, I followed the steps in the `readme.txt` mentioned above to prepare an SD card.

I already had an appropriately formatted SD card so I copied the relevant output files

```bash
rm /media/parallels/boot/*
cp output/images/rpi-firmware/* /media/parallels/boot/
cp output/images/zImage /media/parallels/boot/
sudo rm -rf /media/parallels/fc254b57-8fff-4f96-9609-ea202d871acf/*
sudo tar xf output/images/rootfs.tar -C /media/parallels/fc254b57-8fff-4f96-9609-ea202d871acf/
```

I was able to boot Raspberry Pi with the newly minted headless embedded Linux system, use an HDMI display to log in, and [bring up](https://wiki.debian.org/NetworkConfiguration) the ethernet interface eth0.
