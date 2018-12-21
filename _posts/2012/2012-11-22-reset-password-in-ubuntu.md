---
layout: default
title: Reset password in Ubuntu
tags: grub ubuntu reset password
comments: true
---
# Reset password in Ubuntu

If you have forgotten the root password you can reset it quite easily by booting into single-user mode. Reboot the PC and press ESC. You'll get the GRUB screen below.

![GRUB OS selection](/assets/img/bootloader-grub-ubuntu.png)

Press e to edit the first entry in the boot menu. Add single to the line for the kernel as shown below.

![GRUB boot parameters](/assets/img/bootloader-grub-ubuntu-boot-param.png)

Press F10 to reboot. You'll be booted into the single-user mode and can change the password for any user thus:

```bash
passwd login
```
