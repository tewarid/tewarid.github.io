---
layout: default
title: Calculate Intel HEX file checksum using Windows Calculator
tags: intel hex file format checksum
---

Intel HEX file format is well documented by [KEIL](http://www.keil.com/support/docs/1584/). Here's how you can calculate the checksum if you only have the Windows 7/8 calculator. Let's suppose you have the following data record (ending with the checksum 0xF0)

```text
:10001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0
```

The checksum calculation works by calculating the sum of all the bytes (pair of hex digits), then calculating the one's complement of the result, and adding one to that. The latter two operations are equivalent to calculating the two's complement of the original sum. Thus, using Windows calculator in programmer's mode, base Hex, the checksum can be calculated as follows

```text
10 + 00 + 10 + 00 + FF + FF + FF + 
FF + FF + FF + FF + FF + FF + FF + 
FF + FF + FF + FF + FF + FF = Not + 1 =
```

OR, simplifying a bit

```text
10 + 10 + ( FF * 10 ) = Not + 1 =
```

The simplification is based on the fact that there are 16 (or 0x10 in hexadecimal) 0xFF hexadecimal values and two 0x10 hexadecimal values. That results in a sum of 0x1010 in hexadecimal. Calculating two's complement, by calculating one's complement of that value and adding 1, gives FFFFFFFFFFFFEFF0\. The last byte of that result is the checksum i.e. 0xF0.
