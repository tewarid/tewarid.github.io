---
layout: default
title: Emulating Bluetooth LE Peripheral on Mac OS X Mavericks
tags: bluetooth le emulate macos
---

This post documents some interesting Mac OS X Bluetooth LE peripheral examples I have found.

### Arbitrary Bluetooth Peripheral

Clone example from https://github.com/sandeepmistry/osx-ble-peripheral.

An [issue](https://github.com/sandeepmistry/osx-ble-peripheral/issues/1) is that it duplicates peripheral services after Bluetooth is turned off/on. Calling `removeAllServices` of `CBPeripheralManager`, fixes that.

You can also use `IOBluetoothDevice` API to iterate through connected Central devices. We found situations when after starting the peripheral app, the central app running on an iPhone would not establish Bluetooth LE communication. We were able to use `IOBluetoothDevice` to force disconnect all connected devices at app start on the Mac, to skirt the issue.

### Advertising an iBeacon

Clone example from https://github.com/mttrb/BeaconOSX. Appears on the LightBlue app, but need to actually use it as an iBeacon. Check author's blog at http://www.blendedcocoa.com/blog/2013/11/02/mavericks-as-an-ibeacon/ for further details. On a side note, you can create an [iBeacon using a Raspberry Pi](http://www.theregister.co.uk/2013/11/29/feature_diy_apple_ibeacons/) and an off-the-shelf [USB dongle](http://www.iogear.com/product/GBU521/).
