---
layout: default
title: Prototyping a PCB using LPKF ProtoMat S62
tags:
---

The last time I designed my own PCB, in 1995, I used parchment (butter) paper and stickers. The fabrication was contracted out to a third-party. Times have changed, we now have simple circuit design software such as [Fritzing]({% link _posts/2013/2013-09-26-fritzing-to-design-and-prototype-electronics-circuits.md %}), and rapid PCB prototyping machines such as the LPKF ProtoMat S62\. Though the latter doesn't come cheap, it is totally worth it.

The PCB I designed is very simple, and contains only through-hole parts. It is a custom breakout for the Raspberry Pi Model B Rev 2\. I found most components in the Fritzing library. The Raspberry Pi component was obtained from the Adafruit Fritzing library at [GitHub](https://github.com/adafruit/Fritzing-Library) (AdaFruit.fzbz).

This is how the breadboard view looks

![Fritzing Breadboard View](/assets/img/fritzing-pi-breadboard.jpg)

The schematic after some cleanup looks like this

![Fritzing Schematic View](/assets/img/fritzing-pi-schematic.jpg)

I let Fritzing autoroute traces, and then fixed whatever issues its DRC (design rules checker) brought up.

The two-sided PCB after some work looks like this

![Fritzing PCB View](/assets/img/fritzing-pi-pcb.jpg)

The prototyping environment lacks PTH (plated through hole) capability. Although holes are drilled, we are unable to deposit copper through holes and vias. To enable easier soldering, I moved traces leading away from the header to the top PCB layer. Since the header is placed on the bottom layer, I would only be able to solder its pins on the top layer.

Milling was carried out by a colleague at work, who's trained herself to use the ProtoMat S62 and its accompanying software such as CircuitCam and BoardMaster. She used the Gerber (RS-274X) files I exported using Fritzing.

This is the kind of machine that was used

![ProtoMat S62](/assets/img/protomat-s62.jpg)

Here's how the finished PCB looks (bottom layer appears first)

![PCB bottom](/assets/img/pcb-pi-hat-bottom.jpg)

![PCB top](/assets/img/pcb-pi-hat-top.jpg)

Here's the PCB, with most components now soldered

![PCB bottom](/assets/img/pcb-pi-hat-assembled-bottom.jpg)

![PCB top](/assets/img/pcb-pi-hat-assembled-top.jpg)

Some components are soldered on both sides because they pass signals from one layer to another. As mentioned earlier, we lack PTH capability.

I have a lot to learn about PCB designing and the ProtoMat S62, but it's a start.
