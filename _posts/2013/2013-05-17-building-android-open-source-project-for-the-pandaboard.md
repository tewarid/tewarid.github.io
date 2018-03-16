---
layout: default
title: Building Android Open Source Project for the PandaBoard
tags: aosp android pandaboard build linux
comments: true
---

If you ever decide to build [AOSP](https://source.android.com/) on a Virtual Machine you'll need tonnes of patience. This post describes how to build the AOSP on a Ubuntu 13.04 VM, for the PandaBoard.

### Preparing the VM

I created a VirtualBox (4.2.12) VM with a 100 GB virtual drive on a laptop that has an Intel Core i5 dual core CPU with four logical processors. I configured the VM to use all four logical processors. The amount of physical memory available to the guest OS was configured to four GiB, but you may be able to do with less if you use `make` with less parallel jobs. The host laptop has 8 GB of DDR3 SDRAM. I then installed Ubuntu 13.04 64-bit version from an ISO file.

### Download AOSP source code

This is a lengthy and bandwidth-intensive procedure. I don't want to describe it all since it's [well documented](https://nathanpfry.com/how-to-configure-ubuntu-13-04-raring-ringtail-for-properly-compiling-android-roms/) elsewhere. I chose to build the `android-4.2.2_r1` branch. You may want to add the `-j 20` option to `repo sync` if you have lots of available bandwidth. You'll need a big virtual drive. `du -h` shows that I have used up 13 GB after downloading the source! You'll obviously need much more than that once you are done building, the same folder swelled up to about 35 GB in my case.

### Building AOSP

Again, this is [well documented](https://source.android.com/source/building.html) by the official team. For my build, I chose the target as `full_panda-eng`, since I want to run Android on a PandaBoard. If you restart your VM, you'll need to repeat the entire procedure described in the documentation, right upto the `make` command. If you see the build being killed for no apparent reason, it could be because you have allocated too little memory to the VM. You can also try invoking `make` with less parallel jobs by tweaking the `-`j option e.g. `-j2.`

You'll need to download and extract some proprietary binaries for PandaBoard before starting the build, basically just the graphics driver. Further instructions can be found in file `device/ti/panda/README` under the source tree. If you add the binaries after the build, remember to call `make clobber` to clean up existing output, and then start the build again. The build takes approximately four hours with four simultaneous jobs.

Stay posted for a follow-up post on flashing Android to the PandaBoard.
