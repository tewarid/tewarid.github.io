---
layout: default
title: Case for Raspberry Pi printed with MakerBot Replicator 2
tags:
---

Being able to cheaply produce 3D prototypes makes MakerBot Replicator amazing. We recently acquired a [Replicator 2](http://store.makerbot.com/replicator2) at work, which we used to print a [case](http://www.thingiverse.com/thing:61532) for Raspberry Pi Model B Rev 2.

Here's the result

![Open Case](/assets/img/printing-3d-pi-case-open.jpg)

![Closed Case](/assets/img/printing-3d-pi-case-closed.jpg)

These are some lessons we learned after using the case

* I had a hard time fitting Raspberry Pi into the case. I had to use a box cutter to make several adjustments. I was wishing I had a Dremel.
* I wanted a transparent case, but the printed case is quite opaque. So much so that it is hardly possible to make out which LEDs on the board are lit (see image below).
* It took above an hour to print each half of the case. Be prepared to let the printer do its work for a good few hours.
* The final finish is rough to touch, it appears neatly textured though.
* The case becomes warm to touch after running Raspberry Pi continuously for a day or so, without much CPU load. At 30% CPU load, held for two hours, temperature within the case rises to 35 °C, [CPU/GPU temperature](http://dev.kafol.net/2013/11/measuring-raspberrypi-cpu-and-gpu.html) to 60 °C, at an ambient temperature of 26 °C.
* We have had our Raspberry Pi reboot spontaneously due to RF interference. We'll probably need to go for a metallic case.

Despite all the hard work, a case such as this would have taken us much longer to prototype in the past.
