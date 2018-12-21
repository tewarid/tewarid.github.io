---
layout: default
title: Bluetooth on Raspberry Pi with Buildroot
tags: bluetooth buildroot raspberry pi linux kernel
comments: true
---
# Bluetooth on Raspberry Pi with Buildroot

This post shows how to build Bluetooth support with Buildroot for a Raspberry Pi. You'll need a Bluetooth adapter such as the [Bluetooth 4.0 USB Module](http://www.adafruit.com/products/1327) from Adafruit. That adapter is also Bluetooth Smart (LE) ready.

I recommend using Buildroot 2014.08 because [bluez-tools]({% link _posts/2014/2014-10-24-customize-buildroot-to-build-bluez-tools.md %}) such as bt-adapter and bt-agent work with its version of Bluez.

## Kernel Configuration

Enable Bluetooth subsystem support under Networking support

![Bluetooth subsystem support](/assets/img/buildroot-kernel-networking-bluetooth.png)

Enable [RFCOMM](https://developer.bluetooth.org/TechnologyOverview/Pages/RFCOMM.aspx) protocol support under Bluetooth subsystem support, if you want Bluetooth [SPP](https://developer.bluetooth.org/TechnologyOverview/Pages/SPP.aspx) support. Enable [BNEP](https://developer.bluetooth.org/TechnologyOverview/Pages/BNEP.aspx) protocol support, if you want support for networking over Bluetooth. Enable [HIDP](https://developer.bluetooth.org/TechnologyOverview/Pages/HID.aspx) protocol support, if you want support for Bluetooth enabled keyboard and mice.

![RFCOMM and BNEP support](/assets/img/buildroot-kernel-networking-bluetooth-rfcomm.png)

Since we're using a USB adapter, enable [HCI](https://developer.bluetooth.org/TechnologyOverview/Pages/HCI.aspx) USB driver under Bluetooth subsystem support, Bluetooth device drivers

![HCI USB driver](/assets/img/buildroot-kernel-networking-bluetooth-driver-hci.png)

## Buildroot Packages

The Kernel Bluetooth stack is called BlueZ. BlueZ also provides a set of utilities that can be used from the command line. To add those, select bluez-utils under Target packages, Networking applications

![bluez-utils](/assets/img/buildroot-packages-bluez-utils.png)

If using Buildroot 2014.08, select bluez-utils 5.x package instead

![bluez5_utils](/assets/img/buildroot-packages-bluez-utils-5.png)

`make` the Linux system and copy to SD card.

## Useful commands

Look for interfaces

```
hciconfig -a
```

Bring up HCI interface

```
hciconfig hci0 up
```

Make the device discoverable

```
hciconfig hci0 piscan
```

Scan available devices

```
hcitool scan
```

Ping a device

```
l2ping C8:3E:99:C6:1B:F8
```

Browse capabilities of a device

```
sdptool browse C8:3E:99:C6:1B:F8
```

Run bluetooth daemon

```
bluetoothd
```

If using Buildroot 2014.08

```
/usr/libexec/bluetooth/bluetoothd &
```

Browse local capabilities

```
sdptool browse local
```

Another means to discover available devices, using [bluez-tools]({% link _posts/2014/2014-10-24-customize-buildroot-to-build-bluez-tools.md %})

```
bt-adapter -d
```

Connect and pair with a device listed by the command above

```
bt-device -c 5C:0E:8B:03:6E:4E
```

Create a network connection and obtain IP address

```
bt-network -c C8:3E:99:C6:1B:F8 nap
sudo dhclient bnep0
```

Create a serial port

```
sdptool add --channel=7 SP
rfcomm connect /dev/rfcomm0 C8:3E:99:C6:1B:F8 7
```

Use screen with the above serial port

```
screen /dev/rfcomm0 115200
```

## Bluetooth LE commands

Scan for Bluetooth LE devices

```
hcitool lescan
```

Access services and characteristics provided by an LE peripheral

```
gatttool -b 7F:AE:48:2B:00:0C -t random -I
```

gatttool prompt supports a set of commands to interact with the peripheral

```
connect
primary
char-desc
char-read-hnd handle
char-write-req handle data
```

Enable advertising as an [iBeacon](https://learn.adafruit.com/pibeacon-ibeacon-with-a-raspberry-pi/overview)

```
hciconfig hci0 leadv
hciconfig hci0 noscan
hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61 00
```

Bluetooth is huge! Go ahead and do something with it.
