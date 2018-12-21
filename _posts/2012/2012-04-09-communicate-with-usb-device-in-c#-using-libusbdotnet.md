---
layout: default
title: Communicate with USB device in C# using LibUsbDotNet
tags: libusb .net mono c# macos programming
comments: true
---
# Communicate with USB device in C# using LibUsbDotNet

[LibUsbDotNet](http://sourceforge.net/projects/libusbdotnet/) is a cross-platform library. The source code below has been tested on Mac OS X (version 10.6.8 to be precise) using the Mono .NET run-time. On Linux and Mac LibUsbDotNet requires [libusb](http://www.libusb.org/).

On Mac OS X, you'll need to obtain and build libusb from [source](http://sourceforge.net/projects/libusb/files/libusb-1.0/). Ensure you have downloaded and installed the developer SDK for Mac. To build and install it, execute the following commands from a terminal, in the folder that contains the source of libusb.

```bash
./configure CC="gcc -m32" --prefix=/usr
make
sudo make install
```

The following source code snippet is an example of how to send data to a device. The code itself is a heavily modified version of the Read.Write example that ships with LibUsbDotNet.

{% gist b7928eeb7eafc16cd1fef17f2769378d %}

Here's a sample output produced by the code.

```text
00-02-00-00-00-00-00-06-00-00-00-07-00-00-00-02-01-01-01
IoTimedOut:No more bytes!
```

The same code should run on Windows and Linux. For more details see the [documentation](http://libusbdotnet.sourceforge.net/V2/Index.html) page of LibUSBDotNet. They have a really nice wizard that can create an INF and installer package for Windows.

If Mono raises a System.DllNotFoundException, you might want to take a look at this [page](http://www.mono-project.com/docs/advanced/pinvoke/dllnotfoundexception/).
