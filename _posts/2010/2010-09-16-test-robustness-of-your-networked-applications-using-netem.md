---
layout: default
title: Test robustness of your networked applications using netem
tags: linux kernel netem chaos monkey testing engineering
---

Adverse network conditions that cause corrupt, delayed, dropped, and out-of-order packets, can play havoc with distributed applications.

Linux provides a kernel module called [netem](http://www.linuxfoundation.org/collaborate/workgroups/networking/netem) that can modify network traffic in configurable ways. You can create two networks and use a linux box to [bridge](http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge) these two networks, and configure netem to simulate adverse conditions between the two networks.

If you're building an embedded Linux system, with Buildroot for instance, you can enable netem module under Networking support, Networking options, QoS and/or fair queueing.

![QoS and/or fair queuing](/assets/img/buildroot-kernel-networking-options-qos.png)

![netem](/assets/img/buildroot-kernel-networking-options-netem.png)

You'll need the tc utility from [iproute2](http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2) package to configure netem.

You can enable that package under Target packages, Networking applications

![iproute2](/assets/img/buildroot-packages-iproute2.png)
