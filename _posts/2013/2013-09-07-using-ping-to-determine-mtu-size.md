---
layout: default
title: Using ping to determine MTU size
tags: ping mtu size
---

ping is a ubiquitous and versatile utility available from the command line of most operating systems. Here's how it can be used to determine maximum transmission unit (MTU) size i.e. the maximum amount of data the network will forward in a single data packet.

On Ubuntu GNU/Linux

```bash
ping -s 50000 -M do localhost
```

Here, 50000 is the size of the payload in the ICMP echo request. The `-M do` option prohibits fragmentation. The ICMP message as a whole has 8 more bytes, as that is the size of the header. The command shows that the loopback adapter's MTU size is 16436, and the ping fails.

On Mac OS X

```bash
ping -s 50000 -D localhost
```

Does not print the MTU size, so you'll have to try different payload sizes until you hit the limit. -D prohibits fragmentation by setting the Don't Fragment (DF) bit in the IP header.

On Windows 8

```bash
ping -l 50000 -f localhost
```

Prints the default MTU size as 65500, so the ping above works.
