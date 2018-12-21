---
layout: default
title: Wireshark dissector in Lua for custom protocol over WebSockets
tags: update
comments: true
---
# Wireshark dissector in Lua for custom protocol over WebSockets

It is fairly easy to write a Wireshark dissector in Lua for your custom protocol over WebSockets. To understand the basics of writing, and using, dissectors for Wireshark in Lua, see [Create a Wireshark dissector in Lua]({% link _posts/2010/2010-09-27-create-a-wireshark-dissector-in-lua.md %}).

Here's a template to get you started with writing your custom dissector. Replace port number 8002, with the port number where your WebSocket server listens for incoming connections, and the dissector should be called.

{% gist 0b9569a1f540edb634d904d500fb0247 %}

![WebSocket Protocol Dissector for Wireshark](/assets/img/wireshark-websocket.png)

You can also register the dissector using declared WebSocket protocol name. Retrieve the `ws.protocol` dissector table instead of `ws.port`, and add your dissector to the dissector table using protocol name (a string) instead of port number.

If using WebSockets over SSL/TLS, you need to specify the server's private key file in [SSL protocol dissector](https://wiki.wireshark.org/SSL)'s configuration, so that Wireshark can decrypt the traffic. The protocol field in configuration should be set to `http`.
