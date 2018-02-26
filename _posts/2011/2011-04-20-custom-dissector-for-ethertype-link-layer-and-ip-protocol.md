---
layout: default
title: Custom dissector for ethertype link layer and IP protocol
tags: ethertype ethernet dissector wireshark lua
---

This is how you can replace the default dissector for the IP protocol

```lua
local dissector_table = DissectorTable.get("ethertype")
if dissector_table ~= nil then
    dissector_table:add(0x800, p_myproto)
end
```

If you have a capture file with a different link layer start at [How to Dissect Anything](http://wiki.wireshark.org/HowToDissectAnything).

To test your dissector, this is how you can write binary representation of a message to pcap

```bash
od -Ax -tx1 -v myproto.bin > myproto.hex
text2pcap -l 147 myproto.hex myproto.pcap
```

Valid values of link type specified using option `-l` are in the range 147 to 162.

Next, customize the DLT_USER protocol preferences, so that your dissector gets invoked for link type 147

![DLT_USER protocol preference](/assets/img/wireshark-dlt-preferences.png)

You can do the same thing from a Lua dissector

```lua
local wtap_encap_table = DissectorTable.get("wtap_encap")
wtap_encap_table:add(wtap.USER0, p_myproto)
```
