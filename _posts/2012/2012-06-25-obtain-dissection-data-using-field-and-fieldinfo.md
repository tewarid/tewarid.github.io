---
layout: default
title: Obtain dissection data using Field and FieldInfo
tags: wireshark dissector field information lua
---

The Wireshark Lua API reference documents [Field](https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Field.html) in some detail, this post gives a concrete example to complement the official documentation. If you are not familiar with writing dissectors for Wireshark in Lua, I recommend reading the post [Create a Wireshark dissector in Lua](https://delog.wordpress.com/2010/09/27/create-a-wireshark-dissector-in-lua/).

### Creating a Field extractor

According to the reference on Field cited above, you should create a Field extractor before Dissectors get called. This is how you can create a Field extractor for the source and destination IP addresses of the Internet Protocol.

```lua
local ipsrcf = Field.new("ip.src")
local ipdstf = Field.new("ip.dst")
local ipprotof = Field.new("ip.proto")
```

The name of the fields of any protocol can be obtained by using the autocompletion feature of the Filter text field in the toolbar, or the Filter Expression builder dialog.

### Obtaining Field information

You can call a Field extractor to obtain all values associated with it, in the form of a FieldInfo instance. For instance, the code snippet below shows how you can get the string representation of the source and destination IP addresses. This code snippet only works inside the dissector function.

```lua
local finfo = ipsrcf()
local ipsrcstr = tostring(finfo)
finfo = ipdstf()
local ipdststr = tostring(finfo)
finfo = ipprotof()
local ipprotostr = tostring(finfo)
```

### Packet Information structure

Certain [information](https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Pinfo.html#lua_class_Pinfo) about the packet is already provided to the Lua dissector function by Wireshark. This is how you can obtain the source address for instance: `pkt.net_src`.
