---
layout: default
title: Avoiding HTML5 canvas
tags:
---

Browsers on certain Android devices do not have a hardware accelerated canvas. They do however pan images quite well. The code below modifies the image drag example from my [KineticJS post]({% link _posts/2012/2012-08-05-dragging-a-group-containing-image-and-shapes-using-kineticjs.md %}). This is of course quite a simple use case where Canvas is overkill.

{% gist cd3b8bfafef1b0c4c9be3f29c72654fe %}

You can place pins on the image by clicking anywhere on it. Click or touch a pin and it is removed. Pin placement in the Android browser is broken, pins may not appear where they should. I'll update the post as soon as I discover why.

Once again, enjoy the Crab Nebula!

![HTML DIV](/assets/img/web-html-div-pan.jpg)
