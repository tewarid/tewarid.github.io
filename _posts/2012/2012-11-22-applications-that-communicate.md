---
layout: default
title: Applications that communicate
tags: communication network application programming
comments: true
---

You are building an application that needs to communicate over a network, maybe you have decided to build your own communication protocol. I hope you're doing it because TCP over IP does not meet your needs. I cover some points to keep in mind when developing an application or protocol that communicates over a network.

### Use an existing transport protocol

You'll find it easier to layer your protocol on top of an existing transport protocol such as UDP or TCP over IP. It will require more work otherwise.

### Protocol header

A protocol usually requires a header to transmit relevant information about the message. It can contain information such as version, sender address, receiver address, payload size, sequence number, and so on. One important consideration is the size of the header itself, make it as small as possible so that it does not become a significant overhead.

### Message oriented vs stream oriented

It may be desirable to have message boundaries preserved. For instance, if the protocol has been asked to deliver a particular set of bytes, it should ideally provide the receiver those same set of bytes as a cohesive whole.

TCP is an example of a stream oriented protocol in the sense that there are no clear message boundaries. UDP is message oriented, each message or datagram can be up to approximately 65,000 bytes long.

### Fragmentation and reassembly

Depending on the the size of the data, it will need to be broken into smaller fragments, these are reassembled when received. To reassemble data, data fragments need to be put in the order they are sent. The order can be indicated by adding a sequence number to each fragment. The application may also segment data as required, a protocol does not care for the contents of the data itself, it is blissfully unaware that data is segmented.

IP, and therefore TCP and UDP, transparently perform fragmentation and reassembly of data. TCP also further segments data sent by the application. The segments are reassembled at the receiver and provided to the application as a stream. The segment size needs to be such that the total length of the network packet does not exceed the maximum transmission unit (MTU) of the network.

### Retransmission

If your communication link is unreliable, such as a noisy wireless link, you'll need to retransmit data that does not arrive at the receiver. Retransmission may also be required if data arrives but is corrupted.

One way to implement retransmission is by requiring the receiver to send an acknowledgement when data is correctly received. The sender can use a timer to resend data when an acknowledgement is not received. If multiple simultaneous retries fail, the data transfer attempt may be abandoned, and an error reported to the software layer that uses the protocol. Each data fragment needs a unique identifier that should be used during acknowledgement.

Another way to implement retransmission is for the receiver to request it when a fragment with a particular sequence number is not received, after a more recent fragment has been received. This eliminates the need for acknowledgement.

IP is best effort, it neither retransmits nor prevents duplicate messages from arriving. UDP retains these drawbacks, large datagrams may be dropped if the network is unreliable, they may also arrive out of order. TCP handles retransmission, making it reliable and robust at the cost of throughput.

### Error checking and correction

Error checking codes such as CRC codes can be added to data fragments so that errors during transmission can be detected. Redundancy in the data can ensure that data can be corrected even when there are errors. This is useful in scenarios where retransmission is expensive or not possible at all.

UDP and TCP are capable of checking header and data integrity based on a checksum value. They do not have data correction capability. Since TCP does retransmission, it can recover from errors by asking the sender to retransmit.

### Multiple networks paths

The communication protocol stack may have to deal with multiple network paths to the destination, for instance a Bluetooth PAN and a WiFi link. The decision to choose one over the others may be based on the knowledge of which is more reliable, is currently active, has better throughput and so on. IP prioritizes one interface over the other using routing metric.

### Connection (re)establishment

The state of the connection can be detected using keepalive or heartbeat messages. If the receiver responds to heartbeat messages, the connection is alive. Otherwise, it is considered broken and an error reported to the application. Heartbeat messages compete with regular data, so they may be used when no data activity is present. Connection reestablishment may require user intervention in case of persistent problems with the network.

Protocols such as TCP initiate and maintain a session with the receiver. A termination in this connection is negotiated. TCP supports keepalive, it can be enabled on a per connection basis. UDP on the other hand does not maintain a connection, it is entirely stateless. Termination of a connection due to persistent problems in the network is not handled gracefully by UDP.

### Compression and encryption

Compression can reduce the bandwidth required to transport data. Domain specific compression algorithms are usually more efficient than generic compression algorithms like Deflate, for instance JPEG is better at compressing image data, and MP3 is better at compressing music. Encryption ensures that data cannot be read by parties other than the sender and the receiver. Encryption is quite an elaborate and complex topic involving key exchange, and several kinds of crypto algorithms.

### Rate control

Rate control, also called throttling, prevents the network and network nodes from being overwhelmed, averting effects such as packet loss. It can also be used to divide the available bandwidth between users, when it is scarce. Rate control can also be applied when available bandwidth changes, commonly referred to as adaptive rate control.

### Store and forward

Some considerations need to be made as to what happens to messages when delivery fails, when there is a power outage for instance. The protocol can store messages in a persistent queue and forward them at a later time. This is also sometimes referred to as fire and forget, since the application fires a message and is assured that the other end will receive it, even after a significant delay.

### Software design patterns and data structures

Certain data structures and patterns that can be very useful are queues, priority queues, [observer]({% link _posts/2012/2012-09-14-applying-the-observer-pattern-for-protocol-parsing-and-handling.md %}), and chain of responsibility.
