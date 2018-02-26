---
layout: default
title: PCB Design Software
tags: altium pcb gerbv fritzing eagle design 3d
---

[Altium Designer](http://www.altium.com/altium-designer/) is the design software that I've been using on a regular basis because we've got a license at work. It doesn't come with too many components but more can be downloaded [online](https://designcontent.live.altium.com/). Creating new components is pretty easy too. Components can contain embedded 3D models, which makes it easy to review pad alignment and such. The final PCB can be viewed in 3D too making it really easy to review mechanical constraints.

![3D View in Altium Designer](/assets/img/altium-fixture-3d.png)

These are some useful keyboard shortcuts that come in handy in the PCB design view.

1, 2 or 3 - switch between board planning, 2D layout, and 3D views.
a - alignment pop-up.
ctrl+m - measure distance between two points.
ctrl-z - undo.
escape - exit current tool.
g - change grid resolution.
j - jump to a location.
l - view layer configuration.
p - place.
q - switch between imperial (mils) and international (mm) units.
shift-s - toggle (show/hide) information on other layers.
u - un-route net, connection, component, or room.

Altium provides powerful design rules creation and checking capabilities that come in handy to ensure manufacturability and assembly.

[Circuit Maker](http://circuitmaker.com/) from the makers of Altium is a community driven design software. Designs are stored online and available to all. It feels very much like Altium.

[Eagle](https://cadsoft.io/) is the quintessential PCB design tool used by professionals and hobbyists. Small PCB designs can be done for free. It is useful to have to study open source designs such as the one for [Arduino Uno](https://www.arduino.cc/en/Main/ArduinoBoardUno). There's a lot of information available about and for Eagle such as a wonderful [series of tutorials](https://learn.sparkfun.com/tutorials/how-to-install-and-setup-eagle) from SparkFun.

[Fritzing]({% link _posts/2013/2013-09-26-fritzing-to-design-and-prototype-electronics-circuits.md %}) has become very popular among makers to represent breadboard views of circuits. It also comes with quite powerful PCB editing and verification capabilities. Designs can be exported for manufacturing.

[gerbv](http://gerbv.geda-project.org/) is very useful to review Gerber format manufacturing files. I always review mine in gerbv before sending them off to the manufacturer.

[Land Pattern Calculator](http://www.ipc.org/ContentPage.aspx?pageid=Land-Pattern-Calculator) page can be used to download [PCB Library Expert](http://www.pcblibraries.com/LibraryExpert/) for IPC. It makes calculating land patterns easy. Input the requested dimensions and tolerances, and it outputs the land pattern dimensions for different types of surface mount components.

[123 Design](http://www.123dapp.com/design) is not a PCB design software, but I find it pretty handy to view and tweak 3D models of components.
