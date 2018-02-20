---
layout: default
title: Capture loopback communication on Windows
tags: wireshark npcap loopback
---

# Capture loopback communication on Windows

Wireshark is unable to capture any loopback communication (not just loopback interface) on Windows using WinPcap. You'll need to replace WinPcap with [Npcap](https://nmap.org/npcap/) to be able to do that.

Uninstall WinPcap first.

Select the following options (uncheck support for raw 802.11 traffic at your discretion) during Npcap setup

![Npcap Setup](/assets/img/npcap-setup.png)

To capture loopback traffic, capture on the Npcap loopback Adapter

![npcap-loopback.png](/assets/img/npcap-loopback.png)