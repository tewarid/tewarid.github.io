---
layout: default
title: Bluetooth SPP with Android
tags: bluetooth spp android server serial
comments: true
---
# Bluetooth SPP with Android

Android has had Bluetooth (BT) Serial Port Profile (SPP) server and client capability since [API Level 5](https://developer.android.com/guide/topics/manifest/uses-sdk-element.html) (version 2). Two Android devices, one acting as a [server](https://developer.android.com/reference/android/bluetooth/BluetoothServerSocket.html) and the other as [client](https://developer.android.com/reference/android/bluetooth/BluetoothSocket.html), can communicate over BT SPP.

![Bluetooth SPP Server Terminal](/assets/img/bt-spp-server-android.jpg)

[Bluetooth SPP Server Terminal](https://play.google.com/store/apps/details?id=mobi.minipedia.btserverandroid) app allows you to simulate a BT SPP peripheral. I used it recently to try and simulate a Push-To-Talk [accessory](https://zello.com/accessories.htm) for an app called [Zello](https://play.google.com/store/apps/details?id=com.loudtalks), running on another Android device.

[Bluetooth Terminal](https://play.google.com/store/apps/details?id=ru.sash0k.bluetooth_terminal) is an [open source](https://github.com/Sash0k/bluetooth-spp-terminal) app that can be used to create a BT SPP client connection with other devices, and exchange text and binary data.