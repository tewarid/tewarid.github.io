---
layout: default
title: Join multi-user chat with node-xmpp-client
tags: xmpp node node.js javascript
comments: true
---
# Join multi-user chat with node-xmpp-client

[XEP-0045](http://xmpp.org/extensions/xep-0045.html) defines the XMPP protocol extensions required to join multi-user chat rooms, and receive and post messages. In this post, I use the [node-xmpp-client](https://www.npmjs.com/package/node-xmpp-client) library to join a multi-user chat room. Messages sent to the chat room are received but are not parsed.

node-xmpp-client can be installed using npm, as follows

```bash
npm i node-xmpp-client
```

Here's a script that creates a new XMPP client, and sends a presence stanza to the XMPP server, to join a chat room

```javascript
var Client = require("node-xmpp-client")

var jid = "user@domain"
var password = "password"
var room = "room@domain/nickname"

var client = new Client({
    jid: jid,
    password: password,
    preferred: "PLAIN"
})

client.on("online", function() {
    console.log("online")
    console.log("joining chat room")
    var stanza = new Client.Stanza("presence", {from: jid, to: room})
    client.send(stanza)
})

client.on("stanza", function(stanza) {
    console.log("Incoming stanza: ", stanza.toString())
})

client.on("error", function(e) {
    console.log(e);
})

process.on("SIGINT", function(code) {
    console.log("leaving chat room")
    var stanza = new Client.Stanza("presence", {from: jid, to: room, type: "unavailable"})
    client.send(stanza)

    setTimeout(function() {
        process.exit()
    }, 1000);
})
```

If you don't specify a unique nickname, the XMPP server will likely reject the request to join the room. Modify the above script appropriately, save, and invoke node to execute it

```bash
node muc.js
```

If you get any errors, try again after setting the DEBUG environment variable as follows

```bash
export DEBUG=*
```
