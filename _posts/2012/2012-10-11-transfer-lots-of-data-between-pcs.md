---
layout: default
title: Transfer lots of data between PCs
tags: data transfer ethernet
comments: true
---

So, you just bought a new PC and are wondering how you'll transfer tons of data from one to the other?

Here's a quick tip. You probably have a gigabit Ethernet adapter on both and can use an Ethernet cable to transfer gigabytes of data in a couple of hours.

Just plug a regular Ethernet cable into both PCs, configure network interfaces with  static IP addresses, and you are ready to transfer your data. Older Ethernet adapters may have difficulty with a normal cable, you may need a crossover cable, but most adapters auto-detect crossover and work with regular cables just fine.

Configuring the static IP address is operating system specific. So is file copying. On Windows, use the network adapter settings page to access Internet Protocol version 4 properties. Set the network address to something like 192.168.2.1 on one PC and 192.168.2.2 on the other. Set the network mask on both to 255.255.255.0.

Now, just share a folder or disk you want to copy over the network, and access it from the other PC to copy whatever files you need. I got an average data transfer rate of about 25 Megabytes per second. That is far less than the theoretical 125 MB per second I should get from gigabit Ethernet. Need to figure out why, but it got the job done.

Of course, if you have an external USB drive, you can save yourself the pain above, and use that for doing the transfer, even though it may take at least twice as long.
