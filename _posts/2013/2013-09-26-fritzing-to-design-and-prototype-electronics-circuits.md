---
layout: default
title: Fritzing to design and prototype electronics circuits
tags: fritzing circuit pcb design
comments: true
---
# Fritzing to design and prototype electronics circuits

I have been playing with [Fritzing](http://fritzing.org/) lately, and I have to say I am impressed. It is very easy to create and document electronic designs, and turn them into beautiful working circuits.

Here's an example of an Arduino project documented using the Breadboard view. The components are all available from the parts library built into the tool. [SparkFun](https://www.sparkfun.com/) is a huge contributor, as is [Adafruit](https://github.com/adafruit/Fritzing-Library/).

![Breadboard View](/assets/img/fritzing-breadboard-arduino-pro.png)

The Schematic view is automatically produced as you work in the Breadboard view. It has autoroute support, and it is fairly easy to move things around. The color of the wires has to be chosen manually.

![Schematic View](/assets/img/fritzing-schematic-arduino-pro.png)

The PCB view allows you to quickly produce a PCB design. You can place components on the top and bottom layers, add additional boards, autoroute, and further manipulate wires and components. The tool will even derive the text in the silk screen layers from the labels on the parts. When you're done, you can export for production in the Gerber RS-274x format. The image below shows the Gerber layers exported by Fritzing, as viewed in [Gerbv](http://gerbv.geda-project.org/). This PCB allows an Arduino Pro to be plugged on one side, and several small boards to be plugged on the other side.

![Gerber](/assets/img/gerbv-arduino-pro-gerber.png)
