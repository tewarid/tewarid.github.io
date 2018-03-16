---
layout: default
title: TCP socket connection from the web browser
tags: tcp websocket browser web html javascript
comments: true
---

Web browsers do not support communicating with TCP hosts, other than web servers. In this post I take a different tack. I demonstrate a relay written with Node.js, that receives data from the browser over [websockets](http://www.w3.org/TR/websockets/), and sends it to a TCP socket. Data received over the TCP socket is similarly relayed back to the browser. This approach can also be used with UDP and other IP protocols.

JavaScript implementations of most modern browsers have [typed arrays](http://wiki.ecmascript.org/doku.php?id=strawman:typed_arrays), that can be used to manipulate binary data. Latency and [performance](http://blog.n01se.net/blog-n01se-net-p-248.html) of JavaScript are important factors to consider. Some hosts may have tight timing requirements for responses that may be hard to meet.

The websockets implementation used by the relay is based on the [ws](https://github.com/einaros/ws) module. socket.io is also a good fit but I wanted to be as close to vanilla websockets as possible. The ws module can be installed as follows:

```bash
npm -g install ws
```

### The client

Here's the implementation of a test client. It requests the relay to open a new socket connection to www.google.com at port 80\. It then sends an HTTP GET request, and shows the response to the GET request in a DIV element.

You'll need some familiarity with [jQuery](http://docs.jquery.com/How_jQuery_Works) to follow the code. Since I use the CDN hosted version of jQuery, you'll need an internet connection.

```html
<html>
<head>
  <title>Test Client</title>
</head>
<body>
  <div id="output">Output</div>

  <script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>

  <script>
  $(document).ready(function() {
    var config = {
      relayURL: "ws://192.168.0.129:8080",
      remoteHost: "www.google.com",
      remotePort: 80
    };

    var client = new RelayClient(config, function(socket) {
      socket.onmessage = function(event) {
        $('div#output').html(event.data)
      };
      var get = 'GET / HTTP/1.1\r\n\r\n';
      //var get = new Blob(['GET / HTTP/1.1\r\n\r\n']);
      socket.send(get);
    });
  });

  function RelayClient(config, handler) {
    var connected = false;
    var connectHandler = handler;

    var socket = new WebSocket(config.relayURL);

    socket.onopen = function() {
      socket.send('open ' + config.remoteHost + ' ' + config.remotePort);
    };

    socket.onmessage = function(event) {
      if (!connected && event.data == 'connected') {
        connected = true;
        handler(socket);
      }
    }
  }
  </script>
</body>
</html>
```

### The relay

The relay implementation receives a message from the client containing an open request followed by the remote host and port. After a connection is established with the remote host, it sends a connected message to the client. After that, all messages from the client are simply relayed to the host, and vice-versa.

The ws module is used in tandem with the express web application framework. The express framework is setup to serve static files from the folder where the script is located.

```javascript
var express = require('express');
var net = require('net');
var WebSocketServer = require('ws').Server;

var app = express.createServer();
app.use(express.static(__dirname));
app.listen(8080);

var wss = new WebSocketServer({server: app});

wss.on('connection', function(ws) {
  // new client connection
  var connected = false;
  var host = undefined;

  ws.on('message', function(message) {
    if (!connected && message.substring(0, 4) == 'open') {
      var options = message.split(' ');
      console.log('Trying %s at port %s...', options[1], options[2]);
      host = net.connect(options[2], options[1], function() {
        connected = true;
        ws.send('connected');
      });
      host.on('data', function(data) {
        console.log('Got data from %s, sending to client.', options[1]);
        ws.send(data);
      });
      host.on('end', function() {
        console.log('Host %s terminated connection.', options[1]);
        ws.close();
      });
    } else {
      console.log('Got data from client, sending to host.');
      host.write(message);
    }
  });
});
```

### Some considerations

The data being sent and received is UTF-8, Blob support is [currently limited](http://caniuse.com/blobbuilder) to Firefox and WebKit based browsers for the desktop. The relay mechanism can be extended to support other protocols like UDP.
