---
layout: default
title: Exchanging binary data in the absence of ArrayBuffer
tags:
comments: true
---
# Exchanging binary data in the absence of ArrayBuffer

You want to use jQuery to send binary data using `get()` or `post()`, and discover that it cannot send binary data without a [patch](http://blog.vjeux.com/2011/javascript/jquery-binary-ajax.html). You use the patch and discover that your JavaScript implementation does not support `ArrayBuffer` for some strange reason.

Well then, here's a hack that can work for small amounts of binary data, use an Array of numbers. For instance:

```javascript
var buf = new Array(10);
buf[0] = 0;
buf[1] = 1;
buf[2] = 2;
buf[3] = 3;
buf[4] = 4;
$.post(url, {buffer: buf});
```
