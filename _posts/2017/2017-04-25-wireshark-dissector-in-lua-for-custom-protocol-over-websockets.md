---
layout: default
title: Wireshark dissector in Lua for custom protocol over WebSockets
tags: custom protocol wireshark lua
comments: true
---
# Wireshark dissector in Lua for custom protocol over WebSockets

It is fairly easy to write a Wireshark dissector in Lua for your custom protocol over WebSockets. To understand the basics of writing, and using, dissectors for Wireshark in Lua, see [Create a Wireshark dissector in Lua](_posts/2010/2010-09-27-create-a-wireshark-dissector-in-lua.md).

Here's a template to get you started with writing your custom dissector. Replace port number 8002, with the port number where your WebSocket server listens for incoming connections, and the dissector should be called.

```lua
-- create myproto protocol and its fields
p_myproto = Proto ("myproto","My Protocol")
local f_command = ProtoField.uint16("myproto.command", "Command", base.HEX)
local f_data = ProtoField.string("myproto.data", "Data", FT_STRING)

p_myproto.fields = {f_command}

-- myproto dissector function
function p_myproto.dissector (buf, pkt, root)
  -- validate packet length is adequate, otherwise quit
  if buf:len() == 0 then return end
  pkt.cols.protocol = p_myproto.name

  -- create subtree for myproto
  subtree = root:add(p_myproto, buf(0))
  -- add protocol fields to subtree
  subtree:add(f_command, buf(0,2)):append_text(" [Command text]")

  -- description of payload
  subtree:append_text(", Command details here or in the tree below")
end

-- Initialization routine
function p_myproto.init()
end

-- register a chained dissector for port 8002
local ws_dissector_table = DissectorTable.get("ws.port")
dissector = ws_dissector_table:get_dissector(8002)
  -- you can call dissector from function p_myproto.dissector above
  -- so that the previous dissector gets called
ws_dissector_table:add(8002, p_myproto)
```

![WebSocket Protocol Dissector for Wireshark](/assets/img/wireshark-websocket.png)

You can also register the dissector using declared WebSocket protocol name. Retrieve the `ws.protocol` dissector table instead of `ws.port`, and add your dissector to the dissector table using protocol name (a string) instead of port number.

If using WebSockets over SSL/TLS, you need to specify the server's private key file in [SSL protocol dissector](https://wiki.wireshark.org/SSL)'s configuration, so that Wireshark can decrypt the traffic. The protocol field in configuration should be set to `http`.
