---
layout: default
title: JSON and associative arrays
tags: json javascript
---

JSON does not support serialization of associative (key-value pair) arrays of the kind

```javascript
var a = new Array();
a['a'] = 'a';
a['b'] = 'b';
```

That means Socket.IO and other code that relies on JSON serialization will not work.

It is also not wise to use large numeric values as the array index, for instance

```javascript
var a = new Array();
var id = '1000';
a[id] = 'foo';
```

That will result in an array with 1001 items, where the first 1000 items store nothing. This array when serialized will result in a really long JSON string.

The solution is to use a sequential counter, or use the push method to add an object into the array. Of course, finding an object in a large array will be slow. You'll have to scan array items sequentially till you find the desired object.
