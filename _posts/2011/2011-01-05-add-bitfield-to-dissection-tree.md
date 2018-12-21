---
layout: default
title: Add bitfield to dissection tree
tags: bit field wireshark dissector lua
comments: true
---
# Add bitfield to dissection tree

Wireshark has a limitation in its Lua API. It only supports bitfields - int fields with mask - when using ProtoField, like so

```lua
-- create myproto protocol and its fields
p_myproto = Proto ("myproto","My Protocol")
local f_bitfield = ProtoField.uint8("myproto.bitfield", "Command", base.HEX,
  {[0]="Normal Packet", [1]="Last Packet"}, 0x40)
p_myproto.fields = {f_bitfield}
```

This is cumbersome if you have a large protocol with several bitfields - you'll have to add all of them up front. Here's a helper function to add bitfields to the dissection tree. Its only limitation is that Wireshark highlights all the octets containing the bitfield, in the _Packet Bytes_ pane - when viewing bytes as bits. When using ProtoField, Wireshark highlights just the bits selected by the mask.

```lua
function bitfield_add(buf, subtree, offset, size, bitfieldstart, bitfieldlen,
name, valuestring, desc, format)
    local val = buf(offset, size):bitfield(bitfieldstart, bitfieldlen)
    local binary=""
    local i = bitfieldlen - 1
    local intval = val

    repeat
        local result = intval % 2^i
        if result ~= intval then
            binary = binary.."1"
        else
            binary = binary.."0"
        end
        intval = result
        i = i - 1
    until (i < 0)

    local dotted = string.rep(".", bitfieldstart)..binary
      ..string.rep(".", size*8-bitfieldstart-bitfieldlen)

    local chunked = ""
    for i = 0, size do
        chunked = chunked..string.sub(dotted, 8*i+1, 8*i+4)
          .." "..string.sub(dotted, 8*i+5, 8*i+8).." "
    end

    desc = chunked.." = "..desc
    if format ~= nil then
        desc = desc..": "..string.format(format, val)
    end

    if valuestring ~= nil then
        if valuestring[val] ~= nil then
            desc = desc.." ["..valuestring[val].."]"
        end
    end

    subtree:add(ProtoField.uint8(name), buf(offset, size), desc)
end
```
