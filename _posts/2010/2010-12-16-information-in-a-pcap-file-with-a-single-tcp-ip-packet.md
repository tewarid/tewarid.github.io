---
layout: default
title: Information in a PCAP file with a single TCP/IP packet
tags: pcap tcp format
---

If you need to create packets for your protocol so that you can test a Wireshark dissector, the following information may be useful to you. The PCAP [file format](http://wiki.wireshark.org/Development/LibpcapFileFormat) is well documented in the Wireshark Wiki.

![TCP packet in free hex editor neo](/assets/img/packet-capture-pcap-tcp.jpg)

00 – 24 byte PCAP global header (see magic number 0xa1b2c3d4 sequence to determine how fields are to be read)

18 – 16 byte packet header

<span style="color:#ff0000;">20 – 4 byte length of packet in file (same byte order as magic number)</span>

<span style="color:#ff0000;">24 – 4 byte original length of packet (same byte order as magic number)</span>

28 – 14 byte [Ethernet frame](http://wiki.wireshark.org/Ethernet) header

36 – 20 byte IPv4 header

<span style="color:#ff0000;">38 – Total length of IP packet, includes the IP header and the TCP payload</span>

<span style="color:#0000ff;">40 - 2 byte IP packet checksum</span>

4a - 20 byte TCP header

4a – 2 byte source port

4c - 2 byte destination port

5e - Payload

If you mess around with the payload, the fields in <span style="color:#ff0000;">red</span> are the ones you will need to adjust. The fields in <span style="color:#0000ff;">blue</span> don’t prevent Wireshark from opening the capture file correctly, but may need to be modified. You can fix the IP checksum based on the value calculated by Wireshark.