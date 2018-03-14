---
layout: default
title: Information in a PCAP file with a single UDP packet
tags: pcap udp format
---

If you need to create packets for your protocol so that you can test a Wireshark dissector, the following information may be useful to you. The [PCAP file format](http://wiki.wireshark.org/Development/LibpcapFileFormat) is well documented in the Wireshark Wiki.

![UDP packet in free hex editor neo](/assets/img/packet-capture-pcap-udp.jpg)

|                 Offset                 |                                            Field description                                             |
| :------------------------------------: | -------------------------------------------------------------------------------------------------------- |
|                   00                   | 24-byte PCAP global header (see magic number 0xa1b2c3d4 sequence to determine how fields are to be read) |
|                   18                   | 16-byte packet header                                                                                    |
| <span style="color:#ff0000;">20</span> | <span style="color:#ff0000;">4-byte length of packet in file (same byte order as magic number)</span>    |
| <span style="color:#ff0000;">24</span> | <span style="color:#ff0000;">4-byte original length of packet (same byte order as magic number)</span>   |
|                   28                   | 14-byte ethernet frame                                                                                   |
|                   36                   | 20-byte IPv4 Header                                                                                      |
| <span style="color:#0000ff;">38</span> | <span style="color:#0000ff;">Total length of IP packet including the header</span>                       |
|                   4a                   | 8-byte UDP header starts here                                                                            |
| <span style="color:#ff0000;">4a</span> | <span style="color:#ff0000;">2-byte UDP source port</span>                                               |
| <span style="color:#ff0000;">4c</span> | <span style="color:#ff0000;">2-byte UDP destination port</span>                                          |
| <span style="color:#ff0000;">4e</span> | <span style="color:#ff0000;">2-byte length of payload including UDP header (8 bytes)</span>              |
|                   50                   | 2-byte UDP checksum (anything is checksum validation is disabled)                                        |
| <span style="color:#ff0000;">52</span> | <span style="color:#ff0000;">Payload</span>                                                              |

If you mess around with the payload, the fields in red are the ones you will need to adjust. The fields in blue don't prevent Wireshark from opening the capture file correctly, but may need to be modified.
