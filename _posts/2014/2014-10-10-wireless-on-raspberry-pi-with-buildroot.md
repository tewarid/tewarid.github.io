---
layout: default
title: Wireless on Raspberry Pi with Buildroot
tags: wireless wifi wi-fi raspberry pi buildroot kernel linux
comments: true
---

Raspberry Pi does not have Wi-Fi on board. You'll need to use a Wi-Fi dongle and discover the driver to build into the kernel. One way to find the driver is to plug the dongle into a Raspberry Pi running Raspbian, and run `lsmod` to see which module gets loaded. The following text assumes you're building a custom embedded Linux system using Buildroot.

### Kernel Configuration

Invoke the Kernel configuration utility using `make linux-menuconfig`.

Enable Wireless Networking support under Networking support

![Wireless](/assets/img/buildroot-kernel-networking-wireless.png)

Enable cfg80211 - wireless configuration API, and Generic IEEE 802.11 Networking Stack (mac80211), under Networking Support, Wireless

![cfg80211 and mac80211](/assets/img/buildroot-kernel-networking-wireless-options.png)

Enable EEPROM 93CX6 support under Device Drivers, Misc devices, EEPROM support. Required for RTL8187 module in my Wi-Fi dongle, may not be needed for your particular adapter

![EEPROM 93CX6 support](/assets/img/buildroot-kernel-driver-eeprom-93cx6.png)

Enable Wireless LAN driver support under Device Drivers, Network device support

![Wireless LAN](/assets/img/buildroot-kernel-driver-wireless-lan.png)

Enable [Realtek 8187 and 8187B USB support](http://wireless.kernel.org/en/users/Drivers/rtl8187) under Device Drivers, Network device support, Wireless LAN. Select the driver appropriate for your adapter

![Realtek 8187 and 8187B USB support](/assets/img/buildroot-kernel-driver-realtek-8187.png)

### Package Configuration

Invoke `make menuconfig` within the buildroot folder from a command prompt.

Select package [iw](http://wireless.kernel.org/en/users/Documentation/iw) required to configure wireless networking, under Target packages, Networking applications. Enable [iproute2](http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2) if you want to use the ip utility instead of ifconfig.

![iw](/assets/img/buildroot-packages-iw.png)

Select package [wpa_supplicant](http://wireless.kernel.org/en/users/Documentation/wpa_supplicant) and its sub-packages for WPA/WPA2 support

![wpa_supplicant](/assets/img/buildroot-packages-wpa-supplicant.png)

Perform the build by invoking make, copy the newly minted system to an SD card, and use it to boot up your Raspberry Pi.

### Configure Wireless Networking

List your wireless interfaces

```bash
iw list
```

If you've selected the iproute2 package above, the following should list all network interfaces

```bash
ip link
```

Bring up the wlan0 interface

```bash
ip link set wlan0 up
```

Or

```bash
ifconfig wlan0 up
```

Find the access point you want to connect to

```bash
iw dev wlan0 scan
```

Assuming you're using WPA/WPA2, invoke wpa_passphrase to create config file, and wpa_supplicant to connect to network

```bash
wpa_passphrase your_SSID your_passphrase > your_SSID.conf
wpa_supplicant -B -i wlan0 -c your_SSID.conf
```

Instead, if you want to connect to an open network

```bash
iw dev wlan0 connect your_SSID
```

Request IP address using DHCP

```bash
dhcpcd wlan0
```

Check link status

```bash
iw dev wlan0 link
```

Add nameserver entries to /etc/resolv.conf e.g.

```conf
nameserver 8.8.8.8
nameserver 8.8.4.4
```

Test internet connectivity using ping

```bash
ping www.google.com
```
