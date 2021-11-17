---
layout: default
title: Analyzing iBeacon traffic using nRF BLE Sniffer
tags: ibeacon nrf bluetooth le ble sniffer nordic lua wireshark
comments: true
---
# Analyzing iBeacon traffic using nRF BLE Sniffer

I've been troubleshooting iBeacons lately, and [Bluetooth LE Sniffer](https://www.adafruit.com/product/2269) from Adafruit is my go-to tool for sniffing Bluetooth LE (BLE) traffic such as iBeacon advertisements. iBeacon detection can vary a lot depending on advertisement interval and timing, signal strength and its variance with distance, line of sight&mdash;or lack thereof, and interference with other iBeacons.

[nRF Sniffer software](https://learn.adafruit.com/introducing-the-adafruit-bluefruit-le-sniffer/nordic-nrfsniffer) captures all BLE traffic in libpcap format that can be viewed in Wireshark 2.4. If you're using an older version of Wireshark, [I have ported the native dissector to Lua](https://github.com/tewarid/wireshark-nordic-ble-lua) that should work starting from Wireshark 1.12.

Here's an iBeacon advertisement dissected using the `nordic_ble` Lua dissector, and Wireshark's native `btle` dissector, on macOS. Note that iBeacon payload proprietary to Apple is not yet decoded by Wireshark's `btle` dissector.

![Bluetooth LE Advertisement](/assets/img/btle_adv_ind.png)

Using data from the packet shown above, iBeacon's proprietary payload has the following format

|              Value               |               Description               |
| -------------------------------- | --------------------------------------- |
| 02                               | ID                                      |
| 15                               | Length (21 bytes)                       |
| 3aa46f0c80784773be800255132aefda | 128-bit UUID                            |
| e4f2                             | major number                            |
| e4c1                             | minor number                            |
| b6                               | two's complement of calibrated TX power |

A filter such as `btcommon.eir_ad.entry.data contains e4:f2:e4:c1` can be used to filter packets based on major and minor numbers.
