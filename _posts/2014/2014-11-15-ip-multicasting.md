---
layout: default
title: IP multicasting
tags: multicast udp linux raspberry pi
---

IP multicasting is used to target a group of hosts by sending a single datagram. IP addresses in the range 224.0.0.0 through 239.255.255.255 are [reserved](http://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml) for multicasting.

To find out which hosts on your subnet support multicasting, try

```bash
ping 224.0.0.1
```

Here's a Node.js code snippet that sends UDP datagrams to multicast group 225.0.0.1 at port 8001

```javascript
var dgram = require('dgram');
var s = dgram.createSocket('udp4');
s.bind(8000);
var b = new Buffer("Hello");
s.send(b, 0, b.length, 8001, "225.0.0.1", function(err, bytes) {
  console.log("Sent " + bytes + " bytes");
  s.close();
});
```

A quirk observed on Linux (nay Unix, including OS X) is the need to add a route to forward multicast IP packets

```bash
route add -net 225.0.0.0 netmask 255.0.0.0 gw 192.168.2.1
```

Or

```bash
route add -net 224.0.0.0/4 gw 192.168.2.1
```

Check that the route has been added with

```bash
netstat -nr
```

Or

```bash
route
```

A host that desires to receive a datagram sent to a multicast group, must first request membership to that group. Here's a Node.js code snippet that receives datagram sent by the code above

```javascript
var dgram = require('dgram');
var s = dgram.createSocket('udp4');
s.bind(8001, function() {
  s.addMembership('225.0.0.1');
});
s.on("message", function (msg, rinfo) {
  console.log("server got: " + msg + " from " +
    rinfo.address + ":" + rinfo.port);
});
```

Receiving multicasts on Linux does not work when you bind the socket to a specific interface, for instance `s.bind(8001, 192.168.1.1...` does not work. It looks like a Linux (nay Unix, including OS X) quirk because it is not required on Windows with either Mono .NET runtime or Node.js.

.NET code that does something similar can be found in the [UDP Tool](https://github.com/tewarid/net-tools/tree/master/UdpTool) at GitHub.
