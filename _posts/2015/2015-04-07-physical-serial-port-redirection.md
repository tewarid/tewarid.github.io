---
layout: default
title: Physical serial port redirection
tags: serial port redirection
comments: true
---

I have previously posted about [Virtual serial port redirection on Windows]({% link _posts/2014/2014-01-21-virtual-serial-port-redirection-on-windows-8.md %}), to develop and test applications that use serial ports. I've found the available drivers increasingly buggy on Windows 8.1. This post shows how you can wire two USB-Serial cables to achieve the same objective.

![Serial Port Redirection](/assets/img/serial-redirect.jpg)

You'll need two USB-Serial cables such as [USB to TTL Serial Cable for Raspberry Pi](http://www.adafruit.com/products/954) from Adafruit or several similar ones from Amazon. Wire the cables so that the ground wires are connected, and receive wire of one cable is connected to the transmit of another and vice-versa. Plug the cables in and install the appropriate drivers. Windows usually works with FTDI chipset based cables without requiring installation of drivers.

Now, you should see two serial ports, which redirect data to each other.
