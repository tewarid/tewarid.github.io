---
layout: default
title: Broadcast to all sockets
tags: socket.io websocket node nodejs javascript web
---

The broadcast server example from the socket.io [getting started article](https://socket.io/get-started/chat/) is reproduced below

```javascript
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res) {
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket) {
  console.log('a user connected');
  socket.broadcast.emit('user connected');
  io.emit('to all');
});

http.listen(3000, function() {
  console.log('listening on *:3000');
});
```

The `user connected` event will be broadcast to all sockets except the one that just connected. The `to all` event is broadcast to all the sockets.

You can also broadcast some event to all the sockets in a namespace, for example

```javascript
var ns1 = io.of('/ns1');
ns1.on('connection', function (socket) {
  socket.broadcast.emit('user connected');
  ns1.emit('to all');
});
```

The `to all` event is emitted to all the sockets in namespace `ns1`. If you were to emit using `io.emit` instead, the event would not be received by any of the sockets in `ns1`.

The client script that receives messages for namespace `ns1` may look like this

```html
<script>
  var ns1 = io.connect('http://localhost:3000/ns1');

  ns1.on('to all', function () {
    console.log('to all');
  });
</script>
```
