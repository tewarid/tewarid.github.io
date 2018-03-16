---
layout: default
title: IP fowarding
tags: ip forward network windows
comments: true
---

Normally, commercial operating systems do not act as [routers]({% link _posts/2011/2011-02-25-understanding-ip-subnets-and-routing.md %}). They discard any IP packet with a destination IP address not assigned to an active network interface. It is fairly easy to enable IP forwarding, there are instructions elsewhere to do so on [Windows](https://support.microsoft.com/en-us/kb/323339) and [Linux](http://www.ducea.com/2006/08/01/how-to-enable-ip-forwarding-in-linux/).

You'll also need to add appropriate route settings to the routing table, so that the IP packets are routed through the correct network interface. This can be done using the `route add` command on Windows and Linux.

I have had problems routing multicast packets (IP addresses 224.0.0.0 through 239.255.255.255, formerly referred to as Class D addresses). Windows does not route multicast traffic by default. Using [EnableMulticastForwarding](http://technet.microsoft.com/en-us/library/cc957538.aspx) does not automatically enable it either.
