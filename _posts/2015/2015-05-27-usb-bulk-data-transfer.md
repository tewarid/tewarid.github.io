---
layout: default
title: USB bulk data transfer
tags: usb bulk transfer
---

[USB bulk data transfers](http://www.beyondlogic.org/usbnutshell/usb4.shtml#Bulk) are the more commonly used method of communication between a USB host and a peripheral. In this post, I'll show how you can analyze bulk data transfers captured using a Total Phase Beagle USB 480.

The figure below, shows USB bulk data transfers captured using Total Phase's Data Center software and a Beagle USB 480\. According to the USB specification, all bits in a byte are written to the bus in little-endian fashion, and multi-byte values are also written in little-endian order. While the latter is valid with the Beagle USB 480, single byte values appear in a more readable big-endian order.

![Bulk Transfer](/assets/img/usb-analyzer-bulk-transfer.png)

Each USB bulk data transfer is broken into smaller data transfers. Each of the smaller data transfers is initiated by a token packet, followed by data packets, and an ACK packet.

Incoming transfers are initiated by the host using a token packet that has a packet identifier (PID) of IN (byte 0x69). The PID is contained in the last 4 bits (0x9), the first 4 bits are a one's complement of that value (0x6). The second and third bytes, form a single word in little-endian byte order, containing a 5-bit CRC, followed by a 4-bit endpoint ID, followed by a 7-bit device ID. Thus ASCII hex sequence 81 58 in the figure above, should be interpreted as 0x5881, which results in a CRC of 0x0B, an endpoint ID of 0x1, and a device ID of 0x01.

The device responds to the token packet with data packets, or NAK packet if it is unable to handle the request. The PID of the data packets may be DATA0 (0xC3) or DATA1 (0x4B) for full-speed, and also DATA2 (0x87) for high-speed bulk transfers. The data packet has a maximum payload size determined by the USB specification, and is described by wMaxPacketSize attribute in the endpoint descriptor. It may be 8, 16, 32, or 64 bytes for full-speed bulk endpoints (USB 1.1), and also 512 bytes for high-speed (USB 2.0) bulk endpoints. It is 64 bytes in the capture shown above. The payload is followed by a 2-byte CRC.

The end of a bulk data transfer is signaled by a data packet that has less than wMaxPacketSize bytes. If the last, or only, data packet has wMaxPacketSize bytes, the end is signaled by sending a data packet with a payload size of 0 bytes. The device acknowledges a successful transfer using an ACK packet.

Outgoing transfers work in the same manner. The host initiates data transfer using token packet with PID of OUT (0xE1), followed by data packets. The device acknowledges a successful transfer using an ACK packet. If it is unable to receive data, it sends a NAK packet.

Outgoing bulk data transfers can appear jumbled up with incoming bulk data transfers. Applications that leverage Beagle API need to take this into consideration when parsing data captured on the bus.
