---
layout: default
title: Wireshark and Lua bitwise operations
tags: wireshark lua dissector programming bit operator
---

Lua has shipped a bitwise library since version [5.2](http://www.lua.org/manual/5.2/manual.html#6.7). Wireshark Lua implementation has had the same bitwise operations, but the functions are accessed using table name `bit` instead of `bit32`.

If you are not familiar with writing dissectors for Wireshark - in Lua - I recommend reading [Create a Wireshark dissector in Lua]({% link _posts/2010/2010-09-27-create-a-wireshark-dissector-in-lua.md %}).
