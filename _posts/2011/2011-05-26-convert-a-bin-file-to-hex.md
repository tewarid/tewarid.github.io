---
layout: default
title: Convert a bin file to hex
tags: bin hex srecord
comments: true
---

I was doing some work today that required converting a raw bin file, read from flash memory using JTAG, to hex.

I found the excellent [srecord](http://srecord.sourceforge.net/) utility that does the job, as follows

```cmd
srec_cat.exe file.bin -binary -offset 0x80800000  -o file.hex -intel --line-length=44
```

As I am hacking a AT32UC3 based board, `offset` is where the application is located on that board. `line-length` of 44 produces a hex file that has the same line length as the avr32-objcopy utility.

To convert a hex file to binary

```cmd
srec_cat.exe file.hex -intel -offset -0x80800000 -o file.bin -binary
```

Note the negative `offset`. Without it, the large offset address will result in a binary file that is more than 8 MB long.

[HxD](https://mh-nexus.de/en/hxd/) is a nice freeware binary file editor that you can use to edit the binary file.
