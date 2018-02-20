---
layout: default
title: NXP NTAG I2C NFC Forum tag with Bus Pirate
tags: i2c nfx nxp bus pirate
---

# NXP NTAG I2C NFC Forum tag with Bus Pirate

In this post, I use a Bus Pirate v4.0 to interact with an [NXP NTAG I2C NFC Forum](http://www.nxp.com/products/wireless-connectivity/nfc-and-reader-ics/connected-tag-solutions/demoboard-for-ntag-ic:OM5569-NT312D) tag, over the latter's I2C interface.

Connect Bus Pirate to the tag board as follows

```text
  CLK ↔ SCL
 MOSI ↔ SDA
+3.3V ↔ VCC
  GND ↔ GND
  Vpu ↔ VCC
```

Transition to I2C mode, in hardware, clock rate of 100KHz

```text
HiZ>m
1\. HiZ
2\. 1-WIRE
3\. UART
4\. I2C
5\. SPI
6\. 2WIRE
7\. 3WIRE
8\. KEYB
9\. LCD
10\. PIC
11\. DIO
x. exit(without change)

(1)>4
I2C mode:
 1\. Software
 2\. Hardware

(1)>2
Set speed:
 1\. 100KHz
 2\. 400KHz
 3\. 1MHz
(1)>1
Ready
```

Enable power

```text
I2C>W
POWER SUPPLIES ON
```

Enable pull-ups (the board does not come with any)

```text
I2C>P
Pull-up resistors ON
```

Search for address of tag device

```text
2C>(1)
Searching I2C address space. Found devices at:
0xAA(0x55 W)
```

Read one 16-byte block at 0x00 containing serial number et al

```text
2C>[0xAA 0x00][0xAB r:16]
I2C START BIT
WRITE: 0xAA ACK
WRITE: 0x00 ACK
I2C STOP BIT
I2C START BIT
WRITE: 0xAB ACK
READ: 0x04  ACK 0x47  ACK 0x91  ACK 0x52  ACK 0x56  ACK 0x40  ACK 0x80  ACK 0x00  ACK 0x44  ACK 0x00  ACK 0x00  ACK 0x00  ACK 0xE1  ACK 0x10  ACK 0x6D  ACK 0x00
NACK
I2C STOP BIT
```

Read specified (i.e. 0x00) session register (address 0xFE) byte

```text
I2C>[0xAA 0xFE 0x00][0xAB r]
I2C START BIT
WRITE: 0xAA ACK
WRITE: 0xFE ACK
WRITE: 0x00 ACK
I2C STOP BIT
I2C START BIT
WRITE: 0xAB ACK
READ: 0x01
NACK
I2C STOP BIT
```