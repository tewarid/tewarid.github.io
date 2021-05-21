---
layout: default
title: Convert ASCII Hex text to binary
tags: hex binary .net dotnet c#
comments: true
---
# Convert ASCII Hex text to binary

Debugging sometimes means dumping a hex stream to the console, or to a log file, something like 0x0a 0xff...

I [wrote](https://github.com/tewarid/dotnet-hex-to-bin) a simple command line tool to convert that kind of hex data to binary.

The following are all valid hex values and produce the same binary

* "0xDE 0xAD"
* "0xDE0xAD"
* "0xD E0xAD"
* "0xD\r\nE0xAD"
* "0xDE\r\n 0xAD"
* "0xDE\n 0xAD"
* "0xDE\r 0xAD"
* "0xD\r\nE 0xAD"
* "0x00DE 0xAD"
* "DE AD"
* "DEAD"
* "DEA D"
* "DEA\r\nD"

The following are invalid and will result in an error

* "0x01DE 0xAD"
* "0xDExAD"
* "0xDE AD"
