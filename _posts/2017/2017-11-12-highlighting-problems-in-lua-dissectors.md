---
layout: default
title: Highlighting problems in Lua dissectors
tags: wireshark lua dissector expert info
---

# Highlighting problems in Lua dissectors

Here's a snippet of code from [nordic_ble](https://github.com/tewarid/wireshark-nordic-ble-lua/blob/master/nordic_ble.lua) dissector that shows how you can highlight problems in [Lua dissectors](https://delog.wordpress.com/2010/09/27/create-a-wireshark-dissector-in-lua/) using [add_expert_info](https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Tree.html#lua_class_TreeItem)

```lua
        local item  = tree:add_le(hf_nordic_ble_micok, tvb(UART_PACKET_FLAGS_INDEX, 1), micok > 0)
        if micok == 0 then
            -- MIC is bad
            item:add_expert_info(PI_CHECKSUM, PI_WARN, "MIC is bad")
            item:add_expert_info(PI_UNDECODED, PI_WARN, "Decryption failed (wrong key?)")
```

**NOTE** I recommend using `add_proto_expert_info` because `add_expert_info` is now deprecated.
