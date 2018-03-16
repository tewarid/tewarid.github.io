---
layout: default
title: Dragging a group containing image and shapes using kineticjs
tags: kineticjs javascript jquery programming web
comments: true
---

The code below demonstrates dragging an image that is larger than the stage. Tap or click at a point to add a circle there. The circles and image can be dragged as a group. The group is bound inside the stage so that the entire stage is always occupied by some portion of the image.

{% gist 89340bd58ed478882678423e3b1b3af3 %}

The result works smoothly in mobile Safari and Chrome on the PC. Pan and zoom on a Motorola Xoom tablet with Android 4 (Ice Cream Sandwich) is very jerky.

Enjoy the Crab Nebula!

![KineticJS Group Dragging Example](/assets/img/web-kineticjs-group-drag.png)
