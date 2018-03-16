---
layout: default
title: DIV with scroll
tags: div scroll html
comments: true
---

This is a continuation post to [Avoiding HTML5 Canvas]({% link _posts/2012/2012-08-06-avoiding-html5-canvas.md %}).

If, instead of panning and scrolling the entire browser window, you want to pan or scroll the image inside the DIV, replace lines 18-19 as follows.

```javascript
$('body').css('overflow', 'hidden');
imagediv.css('overflow', 'scroll');
imagediv.width($(window).width() - 10);
imagediv.height($(window).height() - 10);
imagediv.append($('<img src="' + url + '"/>'));
```

I have subtracted some pixels from the width and height of the DIV so that it fits snugly inside the browser window, without the need for scrollbars to pan the DIV itself. A more accurate measure of the scrollbar width can be used instead.

On Safari for iPhone with iOS 6, the height restriction on the DIV has no effect, it is automatically set to the image height by the browser. The width restrictions works all right. On the iPad, and other browsers, the DIV appears snugly within the browser window and the image can be panned using touch-and-drag. I did note the pan to be slightly sluggish, indicating an implementation that is not hardware accelerated.

Pinch to zoom does not work inside the DIV, although the entire document window can be pinched to zoom. I have heard of, but not experimented with, implementations such as [iScroll 4](http://cubiq.org/iscroll-4) that provide this capability. With hardware acceleration lacking, performance may not be all that good.
