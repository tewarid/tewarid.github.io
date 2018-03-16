---
layout: default
title: Data applications on MOTOTRBO radios
tags: mototrbo application development
comments: true
---

MOTOTRBO two-way radios implement the [Digital Mobile Radio](http://dmrassociation.org/) (DMR) standard. They use a channel bandwidth of 6.25 KHz. Small IP datagrams can be sent between radios over the air. This air data network is called the Common Air Interface (CAI) network. A 24-bit radio ID is used along with an 8-bit CAI network ID to form a unique IP v4 address for each radio. Radios that have the same channel configuration can then exchange datagrams using IP addresses.

### IP Peripheral

MOTOTRBO radios can be connected to an IP peripheral, such as a PC, over a USB 1.1 link. A radio acts like a router between the CAI network and the PC. The PC also receives a CAI IP address and can be addressed by other radios. A radio can be configured to forward all datagrams it receives, to the PC.

### Generic Option Board

The radio can also host an embedded board called the Generic Option Board (GOB), designed around an Atmel AVR32 SoC. An application on the GOB can receive raw datagrams sent to a virtual port on the radio. Connectivity to the PC and extensibility using the GOB make the MOTOTRBO radio an attractive platform for delivering small-data applications.

### Non-IP Peripheral

The MOTOTRBO radio can also be connected to a PC or other host as a Non-IP Peripheral, over a USB 1.1 link. Messages sent by other radios, or the GOB, are forwarded to the host over a USB bulk transfer endpoint.

### Bluetooth support

The expanded portfolio MOTOTRBO radios also support Bluetooth. Bluetooth profiles supported are: serial port profile, headset profile, and personal area networking profile. The radio can route data from the connected Bluetooth peripheral to the GOB, and to other radios on the CAI network. This is a paid feature, an additional license is required per radio.

### MOTOTRBO Configurations

MOTOTRBO radios support different configurations to connect with other radios. The simplest configuration is one where one radio broadcasts directly to other radios. Other configurations involve using repeaters. Repeaters, besides extending the range of RF communication, can be interconnected to increase range, and capacity i.e. number of available channels. Repeaters also enable applications to communicate with radios without requiring an intermediary radio.

### Licensed Application Developer

To [develop applications](https://www.motorolasolutions.com/content/dam/msi/docs/partners/developer-program/adk_overview.pdf) for MOTOTRBO radios you need a developer license from Motorola Solutions Inc. Licenses are usually issued on a per app basis for a particular geographical region.
