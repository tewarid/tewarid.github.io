---
layout: default
title: The Architecture of Open Source Applications
tags: aosa book
---

A new book regarding the architecture of several prominent open source projects has been released. They have the whole book online at [http://www.aosabook.org/](http://www.aosabook.org/). It can be purchased from Lulu.com and Amazon.com. Considering that they'll be donating the royalties from the proceeds, buying from Lulu.com makes the most sense, see the breakdown of the proceeds of sale at their site for more details.

Here's a summary of some chapters I read, for their relevance to my current line of work.

### [Chapter 1 - Asterisk](http://www.aosabook.org/en/asterisk.html)

VoIP is hard, and Asterisk does it well. I have used [OpenSIPS](http://www.opensips.org/) (then OpenSer) to implement an [OMA](http://www.openmobilealliance.org) [PoC](http://www.openmobilealliance.org/Technical/release_program/docs/PoC/V1_0_4-20091203-A/OMA-AD-PoC-V1_0_3-20090922-A.pdf) client and a prototype server. That work was scrapped but it taught me enough to know that VoIP projects take significant effort. The Asterisk architecture has evolved over ten years and is quite elegant. Even so, they are working hard on making Asterisk scale. A chapter worth reading.

### [Chapter 10 - Jitsi](http://www.aosabook.org/en/jitsi.html)

[Jitsi](http://www.jitsi.org/) is an open source communicator written in Java. They use a plugins based architecture based on [OSGi](http://www.osgi.org). I have briefly been involved with OSGi as a [TCK](https://www.osgi.org/jsr-291-tck/) developer, so I am not surprised by the fact that its adoption is now widespread. A pity though that, in my opinion, Java has lost its momentum. New smartphones don't run Java VM.

It is hard to use Java in the problem domain that Jitsi serves. Accessing media devices from Java using native code is a pain, so is having to render media with good performance. Using OSGi can help a bit, native code can be isolated into decoupled services. Read the chapter for some excellent design tips on protocol, device, media codec and stream handling. Even if your application is not written in Java, this separation of concerns is by itself very useful.

### [Chapter 20 - Telepathy](http://www.aosabook.org/en/telepathy.html)

[Telepathy](http://telepathy.freedesktop.org/wiki/) is a service oriented approach to providing communications capabilities to all Linux apps. It uses the [D-Bus](http://www.freedesktop.org/wiki/Software/dbus) to link together different components (and clients). Using Telepathy along with [Farsight2](https://www.freedesktop.org/wiki/Software/Farstream/) (now Farstream), which is a media streaming framework based on [GStreamer](http://gstreamer.freedesktop.org/), one can build VoIP applications for Linux. [Empathy](http://live.gnome.org/Empathy), the default messaging program on Ubuntu, is one prominent application that uses this infrastructure.

### Conclusion

Each chapter is a treatise on the architecture of a particular open source project, but it is disheartening to observe the lack of reuse between them.

Also, there are some significant open source applications missing

* Apache HTTPD
* The Linux Kernel
* WebKit engine or the Chrome browser
