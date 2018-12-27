---
layout: default
title: Avoiding HTML5 canvas
tags:
comments: true
---
# Avoiding HTML5 canvas

Browsers on certain Android devices do not have a hardware accelerated canvas. They do however pan images quite well. The code below modifies the image drag example from my [KineticJS post]({% link _posts/2012/2012-08-05-dragging-a-group-containing-image-and-shapes-using-kineticjs.md %}). This is of course quite a simple use case where Canvas is overkill.

```html
<html>
<head>
  <title>no canvas</title>
  <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
</head>
<body>
  <div id="container">
    <div id="imagediv" style="overflow: hidden"></div>
  </div>
  <script>
  $(document).ready(function() {
    var image = new Image();
    var url = 'https://apod.nasa.gov/apod/image/0802/crabmosaic_hst_big.jpg';

    image.onload = function() {
      var imagediv = $('div#imagediv');

      imagediv.css('background', 'url(' + url + ')');
      imagediv.width(image.width);
      imagediv.height(image.height);

      var idCount = 1;

      imagediv.on('click', function(event) {
        // this gets us a 16x16 px pin - deprecated by google
        var pinUrl = 'https://chart.googleapis.com/chart?chst=d_simple_text_icon_left&chld=|14|000|glyphish_target|24|0f0|FFF';

        // place pin on top of the image
        var pinid = 'pin'+idCount;
        idCount++;

        $('div#container').append('<div id="' + pinid + '"></div>');

        var pinselector = '#'+pinid;
        var pindiv = $(pinselector);
        pindiv.css('width', '24px');
        pindiv.css('height', '24px');
        pindiv.css('position', 'absolute');
        pindiv.css('left', event.pageX - 12);
        pindiv.css('top', event.pageY - 12);
        pindiv.css('background', 'url(' + pinUrl + ')');

        $(pinselector).on('click', '', pinselector, function(event) {
          $(event.data).remove();
        });
        idCount++;
      }); // imagediv click
    }

    image.src = url; // this will fire onload event
  });
  </script>
</body>
</html>
```

You can place pins on the image by clicking anywhere on it. Click or touch a pin and it is removed. Pin placement in the Android browser is broken, pins may not appear where they should. I'll update the post as soon as I discover why.

Once again, enjoy the Crab Nebula!

![HTML DIV](/assets/img/web-html-div-pan.jpg)
