---
layout: default
title: Dragging a group containing image and shapes using kineticjs
tags: kineticjs javascript jquery programming web
comments: true
---
# Dragging a group containing image and shapes using kineticjs

The code below demonstrates dragging an image that is larger than the stage. Tap or click at a point to add a circle there. The circles and image can be dragged as a group. The group is bound inside the stage so that the entire stage is always occupied by some portion of the image.

```html
<html>
<head>
  <title>kinetic.js image and shapes dragging using a group</title>
  <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/kineticjs/5.2.0/kinetic.min.js"></script>
</head>
<body>
  <div id="container"></div>

  <script type="text/javascript">
  $(document).ready(function() {
    init();
  });

  function init() {

    var imageObj = new Image();

    imageObj.onload = function() {
      var kimage = new Kinetic.Image({
        image: imageObj,
        x: 0,
        y: 0,
        width: 0,
        height: 0
      });

      var stage = new Kinetic.Stage({
        container: 'container',
        width: 860,
        height: 640
      });

      var layer = new Kinetic.Layer();

      var group = new Kinetic.Group({
        draggable: true,

        dragBoundFunc: function(pos) {
          var newX = 0;
          if (pos.x < 0) {
            newX = pos.x < stage.getWidth() - kimage.getWidth() 
              ? stage.getWidth() - kimage.getWidth() : pos.x;
          }

          var newY = 0;          
          if (pos.y < 0) {
            newY = pos.y < stage.getHeight() - kimage.getHeight() 
              ? stage.getHeight() - kimage.getHeight() : pos.y;
          }

          return {
            x: newX,
            y: newY
          };
        }
      });

      kimage.on('click tap', function(event) {
        // create a circle wherever the user clicks or taps
        var circle = new Kinetic.Circle({
          x: event.offsetX - group.getX(),
          y: event.offsetY - group.getY(),
          radius: 20,
          fill: 'red',
          stroke: 'black',
          strokeWidth: 4
        });

        // circle can be removed from parent group when clicked or tapped
        circle.on('click tap', function(event) {
          circle.remove();
          layer.draw();
        });
        group.add(circle);
        layer.draw();
      });

      group.add(kimage);
      layer.add(group);
      stage.add(layer);
      layer.draw();
    }
    imageObj.src = 'https://apod.nasa.gov/apod/image/0802/crabmosaic_hst_big.jpg';
  }
  </script>
</body>
</html>
```

The result works smoothly in mobile Safari and Chrome on the PC. Pan and zoom on a Motorola Xoom tablet with Android 4 (Ice Cream Sandwich) is very jerky.

Enjoy the Crab Nebula!

![KineticJS Group Dragging Example](/assets/img/web-kineticjs-group-drag.png)
