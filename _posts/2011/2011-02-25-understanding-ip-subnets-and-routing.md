---
layout: default
title: Understanding IP subnets and routing
tags: ip route routing network
comments: true
---

This post is an attempt to remind myself about IP routing when I come back to it after a gap of a year or two.

IP version 4 uses a 32-bit address represented as four octets in the decimal notation, separated by dots e.g. 192.168.1.1. This implies that we can provide a unique address to more than four billion computing devices. Assuming for the moment that 4 billion addresses is enough, we cannot connect all those four billion computers in a single large network. The bandwidth of the medium would have to be infinite, interconnections would have to be very long, each computer would have to receive and discard a lot of information not destined for it, and lots of other physical limitations.

The quite obvious solution is to break the problem down, which means creating several small networks and somehow interconnecting them. To do that we bring into existence an entity called the router, which has a physical presence in one or more sub-networks and can selectively traffic data from one network to another. We also divide an IP address into two parts, the network address and the host address. This division is stated by using a subnet mask.

The immediate advantage of this scheme is that traffic destined to a subnet is seen only by hosts within that subnet. This is is good for security as well as for scaling the network.
