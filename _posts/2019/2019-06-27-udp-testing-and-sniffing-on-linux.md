---
layout: default
title: UDP testing and sniffing on Linux
tags: netcat nc alpine linux tcpdump
comments: true
---
# UDP testing and sniffing on Linux

This post shows how you can send out test UDP packets from an Alpine Linux machine, and use tcpdump to sniff UDP packets.

Install netcat in the machine and try sending out UDP packets to some host at port `8001`

```bash
apk update
apk add netcat-openbsd
nc -u -p 8000 172.20.36.98 8001
```

The UDP socket is bound to port `8000`. Type in any text and hit enter key to send.

Use `tcpdump` to see UDP packets with port `8000` on interface `eth0`

```bash
apk add tcpdump
tcpdump -vv -x -X -i eth0 "port 8000"
```
