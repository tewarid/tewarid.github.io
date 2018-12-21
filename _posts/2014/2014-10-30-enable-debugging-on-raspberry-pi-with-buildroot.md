---
layout: default
title: Enable Debugging on Raspberry Pi with Buildroot
tags: gdb gdbserver buildroot linux raspberry pi
comments: true
---
# Enable Debugging on Raspberry Pi with Buildroot

This is a quick post that shows how to enable gdb and/or gdbserver on the Raspberry Pi when using Buildroot.

Enable option Build packages with debugging symbols, under Build Options

![debugging symbols](/assets/img/buildroot-build-options-symbols.png)

Enable the following options under Toolchain

* Build cross gdb for the host - to facilitate remote debugging
* Thread library debugging - to enable adding gdb and gdbserver packages to the device's root file system

![cross gdb on host](/assets/img/buildroot-toolchain-cross-gdb.png)

![Thread library debugging](/assets/img/buildroot-toolchain-thread-lib-debug.png)

Select gdb and gdbserver (useful for remote debugging), under Target packages, "Debugging, profiling and benchmark"

![gdb and gdbserver](/assets/img/buildroot-packages-gdb.png)
