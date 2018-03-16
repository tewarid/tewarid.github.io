---
layout: default
title: Linux NAT routing on Raspberry Pi with Buildroot
tags: linux kernel nat routing buildroot raspberry pi
comments: true
---

This post documents the kernel modules and other packages required to build an embedded Linux NAT router using Buildroot, for Raspberry Pi.

### Modify Linux kernel configuration

Invoke `make linux-menuconfig` in buildroot folder to initiate kernel configuration utility. Select modules shown in the figures below.

Ensure that the following is enabled under Networking Options

* Network packet filtering framework (Netfilter)

![Networking Options](/assets/img/buildroot-kernel-networking.png)

![Network packet filtering framework](/assets/img/buildroot-kernel-networking-npf.png)

Ensure that the following are enabled under Core Netfilter Configuration

* Netfilter connection tracking support
* Netfilter Xtables support (required for ip_tables)
* "conntrack" connection tracking match support
* "state" match support

![Core Netfilter Configuration](/assets/img/buildroot-kernel-networking-netfilter.png)

Ensure following is enabled under Network packet filtering framework (Netfilter)

* Advanced netfilter configuration

![IP: Netfilter Configuration](/assets/img/buildroot-kernel-networking-netfilter-config.png)

Ensure the following modules are selected under IP: Netfilter Configuration

* IPv4 connection tracking support (required for NAT)
* IP tables support (required for filtering/masq/NAT)
* Packet filtering
* IPv4 NAT
    * MASQUERADE target support
    * NETMAP target support
    * REDIRECT target support

Enable other targets if you want to do sophisticated filtering.

![IPv4 packet filtering and NAT](/assets/img/buildroot-kernel-networking-netfilter-config-ip.png)

### Modify Buildroot Configuration

Include iptables utility package shown in the figure below, using the configuration utility invoked by executing `make menuconfig`. Include tcpdump if you want to sniff network data.

![Buildroot iptables](/assets/img/buildroot-packages-iptables.png)

Now, just execute make to build the system, and copy the kernel image and root file system to SD card.

### Perform NAT routing

I use the following commands to bring up the network interfaces and setup NAT forwarding. Any packets received on interface eth0 are forwarded to usb0\. Only packets for connections already established are forwarded back to eth0\. usb0 is a USB CDC ethernet interface of the kind seen in modems.

```bash
ifconfig usb0 up
ifconfig eth0 up
dhcpcd
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o usb0 -j MASQUERADE
iptables -A FORWARD -i usb0 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o usb0 -j ACCEPT
```

If you get any of the following error messages with iptables, you are probably missing one of the kernel modules mentioned above

```text
iptables v1.4.21: can't initialize iptables table `nat': Table does not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.
```

```text
iptables v1.4.21: can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.
```

```text
iptables: No chain/target/match by that name.
```

If the NAT router is not the default gateway on downstream hosts and routers, you'll have to setup static routes to relay packets upstream. This can be done using a command such as the following on Mac OS X

```bash
sudo route -n add -net 10.0.0.0/8 192.168.2.1
```

Or, on Linux

```bash
route add -net 10.0.0.0/8 gw 192.168.2.1
```

Finally, a couple of useful commands to troubleshoot IP routing and forwarding.

List all rules in iptables

```bash
iptables -L -v
```

Flush all rules in iptables

```bash
iptables --flush
```

A basic packet sniffer

```bash
tcpdump -A -i usb0
```

List all routes

```bash
netstat -nr
```
