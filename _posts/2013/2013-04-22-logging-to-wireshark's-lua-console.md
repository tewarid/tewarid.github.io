---
layout: default
title: Logging to Wireshark's Lua console
tags: wireshark log lua programming
---

A Lua script can log to the Lua Console of Wireshark by using built-in [utility functions](http://wiki.wireshark.org/LuaAPI/Utils). For instance warn("hello world"), prints that text to the console prefixed with date and time information and the text WARN. The console needs to be open for the information to appear. It can be opened from Lua sub-menu under Tools.
