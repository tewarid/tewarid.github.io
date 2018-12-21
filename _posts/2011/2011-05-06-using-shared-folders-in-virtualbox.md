---
layout: default
title: Using shared folders in VirtualBox
tags: vbox virtualbox shared folder
comments: true
---
# Using shared folders in VirtualBox

The shared folder concept in VirtualBox is extremely useful for sharing files between the host and guest OS. To be able to use shared folders on the guest OS, you need to install VirtualBox guest additions. This is usually achieved by using the _Install Guest Additions..._ option from the Devices menu. The next step is to create a shared folder using the _Shared Folder..._ option from the _Devices_ menu.

To access the shared folder in Linux, mount it as follows

```bash
mount -t vboxsf share_name mount_point
```

_share_name_ is the name you gave to the shared folder. Use all upper case - even if the name you gave is in smaller case. _mount_point_ is the folder on the guest OS where the shared folder will be mounted - usually a folder under `/mnt`.

If you set the _Auto-Mount_ option while creating the shared folder, you don't need to manually mount the shared folder.

You'll need to add your login to the `vboxsf` group to be able to access it

```bash
sudo adduser login vboxsf
```

Remember to log out and in again, or reboot, after doing that.
