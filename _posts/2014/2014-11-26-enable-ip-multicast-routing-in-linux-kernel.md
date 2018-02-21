---
layout: default
title: Enable IP multicast routing in Linux kernel
tags: multicast buildroot kernel udp smcroute glibc iptables linux raspberry pi
---

In this post I discuss how to enable multicast routing in a Linux system. It is a continuation to the post [Wireless Router with Buildroot and Raspberry Pi]({% link _posts/2014/2014-10-29-wireless-router-with-buildroot-and-raspberry-pi.md %}), where I discussed how to build a basic Wi-Fi router with a Raspberry Pi. You'll want to read that first.

## Linux kernel configuration

Besides the Kernel modules mentioned in the post(s) linked above, you'll need a few additional modules.

Under Networking support, Networking options, enable

* IP: multicasting
* IP: tunneling - this is required if you want to use tunneling with [mrouted](https://github.com/troglobit/mrouted)
* IP: multicast routing and its sub-options
* The IPv6 protocol

![IP multicast routing and tunneling](/assets/img/buildroot-kernel-networking-multicast.png)

![IPv6 protocol](/assets/img/buildroot-kernel-networking-ipv6.png)

In the absence of IPv6 [smcroute](https://github.com/troglobit/smcroute) fails with an error such as

```text
Starting static multicast router daemon: INIT: ICMPv6 socket open; Errno(97): Address family not supported by protocol
INIT: MRT6_INIT failed; Errno(97): Address family not supported by protocol
smcroute.
```

Under Networking support, Networking options, The IPv6 protocol, enable IPv6: multicast routing and its sub-options.

![IPv6 Multicast Routing](/assets/img/buildroot-kernel-networking-multicast-ipv6.png)

Enable packet mangling with TTL target support if you require support for changing TTL values with iptables.

![Packet Mangling](/assets/img/buildroot-kernel-networking-netfilter-mangling.png)

## Buildroot package configuration

The following Buildroot packages provide daemons for performing multicast routing. Enable mrouted and smcroute under Target packages, Networking applications. mrouted requires a glibc based toolchain, you will have to enable it instead of uClibc if you want to use mrouted.

![mrouted](/assets/img/buildroot-packages-mrouted.png)

![smcroute](/assets/img/buildroot-packages-smcroute.png)

Perform build and prepare the SD card.

## Setup multicast routing

The following procedure is performed from a root console. I usually use the serial console through the expansion header.

Use mrouted when proper IGMP signaling exists

```bash
mrouted
```

The default configuration file `/etc/mrouted.conf` should be enough, unless you want to perform tunneling.

If you don't have proper IGMP signaling happening, you can still perform static multicast routing using

```bash
smcroute -d
```

smcroute requires a configuration file, which in my case is `/etc/smcroute.conf` and looks something like

```conf
mgroup from wlan0 group 225.0.0.1
mroute from wlan0 group 225.0.0.1 to usb0
```

If you don't have an application and want to use ping to test mutlicast, you can enable ICMP echo responses thus

```bash
echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
```

You can use ping requests and receive responses from destination hosts

```bash
ping -t 10 225.0.0.1
```

Note the use of the time to live (TTL) parameter -t. Linux and Mac OS X will set TTL to 1 before forwarding message to the default gateway. You can dump ping messages with TTL parameter using

```bash
tcpdump -v host 224.0.0.1 or 225.0.0.1
```

Note change in TTL from 10 to 1 in a packet routed through Mac OS X in the following dump

```text
14:49:19.642140 IP (tos 0x0, ttl 10, id 0, offset 0, flags [DF], proto ICMP (1), length 84)
    10.211.55.12 > 225.0.0.1: ICMP echo request, id 4113, seq 92, length 64
14:49:19.642190 IP (tos 0x0, ttl 1, id 32573, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.2.10 > 225.0.0.1: ICMP echo request, id 4113, seq 92, length 64
```

If all is well with the routing daemon, IP [variable](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt) `/proc/sys/net/ipv4/conf/{all,interface}/mc_forwarding` will be set to 1.

Some other files offer useful hints related to [multicast routing](http://www.linuxjournal.com/article/6070). The following lists interfaces where multicast routing is active

```bash
cat /proc/net/ip_mr_vif
```

This lists multicast routing cache entries

```bash
cat /proc/net/ip_mr_cache
```

When using static multicast routing with smcroute, routing will work only when TTL is greater than 1\. If the downstream hosts are transmitting packets with TTL at 1, you can use iptables to set TTL thus

```bash
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64
```

I've also had to wait a while after executing smcroute for NAT to kick in, so that source IP address is translated to address of interface on the destination network. Note the change in source IP address in a message sequence captured using

```bash
tcpdump -v -i usb0 host 224.0.0.1 or 225.0.0.1
```

```text
03:03:25.393056 IP (tos 0x0, ttl 63, id 16103, offset 0, flags [none], proto UDP (17), length 41)
    192.168.2.10.61312 > 225.0.0.1.4007: UDP, length 13
03:04:22.277348 IP (tos 0x0, ttl 63, id 8095, offset 0, flags [none], proto UDP (17), length 41)
    192.168.10.2.61312 > 225.0.0.1.4007: UDP, length 13
```
