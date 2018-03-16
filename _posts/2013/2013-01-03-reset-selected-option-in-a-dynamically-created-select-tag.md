---
layout: default
title: Reset selected option in a dynamically created select tag
tags: html select bug
comments: true
---

I have noted a strange issue in Chrome with the select tag. I use code like the following to dynamically create options for a select tag with jQuery

```javascript
var s = $('#selectid');
s.append('option 1');
s.append('option 2');
s.prop('selectedIndex', -1);
```

Note the last statement, I needed it to deselect the first option, most browsers will select it by default. With IE 9 the last statement works all right. It does not with Chrome.

The following is a modified version of the first code snippet that works with Chrome

```javascript
var s = $('#selectid');
s.append('option 1');
s.append('option 2');
setTimeout(function() {
  s.prop('selectedIndex', -1);
}, 100);
```

One side-effect of `setTimeout` is that the user may sometimes see the first option selected momentarily. Reducing the timer interval to let's say 50 ms does not work.
