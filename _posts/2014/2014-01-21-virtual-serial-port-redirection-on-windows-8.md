---
layout: default
title: Virtual serial port redirection on Windows 8
tags: virtual serial windows
---

Virtual serial ports are a convenient way to test software that accesses hardware over serial ports, particularly when that hardware is not available yet. They can also be useful for logging and tracing purposes.

I maintain a simple [tool](https://github.com/tewarid/net-tools/tree/master/SerialTool) that allows me to open serial ports, and send and receive data. It is developed using C# and works reasonably well on Linux with Mono. That is the tool I used to test the different redirectors described below.

* Free Virtual Serial Ports

    Free [Virtual Serial Ports](https://www.hhdsoftware.com/virtual-serial-ports) version 2.11 by HHD Software works on Windows, right up to version 8.1 64-bit. It is easy to create two bridged serial ports, where data sent to one port arrives at the other and vice-versa. I also love Free Hex Editor Neo by HHD Software.

* HW VSP3

    [HW VSP3](http://www.hw-group.com/products/hw_vsp/index_en.html) version 3.1.2 does serial to TCP redirection. It requires a TCP server at the other end. One way to set that up is to use ncat utility that accompanies [NMAP](http://nmap.org/). I have had the need to play with TCP so often, I have rolled my own little [tool](https://github.com/tewarid/net-tools/tree/master/TcpClientTool).

    I found that HW VSP3 sends additional data when a connection is established. It also tended to corrupt data during large transfers. It works all right for small controlled tests.

* Commercial options

    Commercial options that are popular are [Virtual Serial Port Driver](http://www.eltima.com/products/vspdxp/) by Eltima, and [Virtual Serial Port Kit](http://www.fabulatech.com/virtual-serial-port-kit.html) by FabulaTech.
