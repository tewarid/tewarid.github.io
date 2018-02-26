---
layout: default
title: Linux USB ethernet gadget driver for RNDIS connection establishment
tags: rndis message sequence
---

In this post I'll document the RNDIS control message sequence between the USB RNDIS gadget driver and the device.

For those who are not familiar with RNDIS I refer you to Microsoft's [RNDIS](http://msdn.microsoft.com/en-us/library/ff570660.aspx) page or the downloadable [spec](http://msdn.microsoft.com/en-us/library/ee524902.aspx). In particular, you'll need to become familiar with how RNDIS is [mapped to USB](http://msdn.microsoft.com/en-us/library/ff570657.aspx). You'll also need to have good familiarity with the [USB](http://www.ganssle.com/articles/usb.htm).

This list summarizes the mapping

* USB Device
    * Interface #0
        * Endpoint #0 - Control endpoint, id 0x80 (IN) or 0x00 (OUT)
        * Endpoint #1 - Interrupt transfer, id 0x81 (IN)
    * Interface #1
        * Endpoint #3 - Bulk data transfer, id 0x03 (OUT)
        * Endpoint #2 - Bulk data transfer, id 0x82 (IN)

The above can be reproduced quite easily using the `lsusb -v` command in Linux.

Armed with that information I used Wireshark to [sniff the USB bus]({% link _posts/2011/2011-08-19-sniff-usb-bus-on-linux.md %}). The USB capture is usually very verbose, I used the filter `usb.data_flag == "present (0)"` to get to the relevant packets.

Here's the sequence of control messages that establish RNDIS communication. The first four bytes in the hex stream is the message id, in little endian order.

The `REMOTE_NDIS_INITIALIZE_MSG` sent by the driver, over EP 0x00

```text
0000   02 00 00 00 18 00 00 00 01 00 00 00 01 00 00 00
0010   00 00 00 00 40 06 00 00
```

The `REMOTE_NDIS_INITIALIZE_CMPLT` message sent by the device, over EP 0x80

```text
0000   02 00 00 80 34 00 00 00 01 00 00 00 00 00 00 00
0010   01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
0020   01 00 00 00 16 06 00 00 02 00 00 00 00 00 00 00
0030   00 00 00 00
```

A `REMOTE_NDIS_QUERY_MSG` message sent by the driver over EP 0x00. The OID is 0x00010202 (no official documentation)

```text
0000   04 00 00 00 1c 00 00 00 02 00 00 00 02 02 01 00
0010   00 00 00 00 14 00 00 00 00 00 00 00
```

The `REMOTE_NDIS_QUERY_CMPLT` message sent by device as a reply, over EP 0x80

```text
0000   04 00 00 80 18 00 00 00 02 00 00 00 bb 00 00 c0
0010   00 00 00 00 00 00 00 00
```

Status is `RNDIS_STATUS_NOT_SUPPORTED`.

The `REMOTE_NDIS_QUERY_MSG` message sent by the driver to discover the MAC address, over EP 0x00

```text
0000   04 00 00 00 4c 00 00 00 03 00 00 00 01 01 01 01
0010   30 00 00 00 14 00 00 00 00 00 00 00 00 00 00 00
0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0030   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0040   00 00 00 00 00 00 00 00 00 00 00 00
```

The OID queried is `OID_802_3_PERMANENT_ADDRESS`.

The `REMOTE_NDIS_QUERY_CMPLT` message sent by device with the MAC address, over EP 0x80

```text
0000   04 00 00 80 1e 00 00 00 03 00 00 00 00 00 00 00
0010   06 00 00 00 10 00 00 00 0a 00 3e 97 c5 df
```

Query status is `RNDIS_STATUS_SUCCESS`.

The `REMOTE_NDIS_SET_MSG` message send by the driver, over EP 0x00

```text
0000   05 00 00 00 20 00 00 00 04 00 00 00 0e 01 01 00
0010   04 00 00 00 14 00 00 00 00 00 00 00 2d 00 00 00
```

The OID being set is `OID_GEN_CURRENT_PACKET_FILTER`, with the value `NDIS_PACKET_TYPE_PROMISCUOUS | NDIS_PACKET_TYPE_BROADCAST | NDIS_PACKET_TYPE_ALL_MULTICAST | NDIS_PACKET_TYPE_DIRECTED`.

The `REMOTE_NDIS_SET_CMPLT` message sent by the device in reply, over EP 0x80

```text
0000   05 00 00 80 10 00 00 00 04 00 00 00 00 00 00 00
```

After the control message sequence is completed with success, rest of the communication is done using the `REMOTE_NDIS_PACKET_MSG` message (0x00000001) over the bulk transfer endpoints.
