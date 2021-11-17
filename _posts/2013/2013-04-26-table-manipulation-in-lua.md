---
layout: default
title: Table manipulation in Lua
tags: lua table programming wireshark
comments: true
---
# Table manipulation in Lua

In Lua, arrays are tables. Tables can be iterated over using built-in functions such as [`pairs`](http://www.lua.org/manual/5.1/manual.html#pdf-pairs). Tables can have [index](http://www.lua.org/pil/11.5.html) values that are non-numeric.

The following example creates two tables, adds contents of one to another, and prints out the data in the resulting table

```lua
table1 = {
  ["red"] = {Description="Red", RGB=0xFF0000},
  ["green"] = {Description="Green", RGB=0x00FF00}
}

table2 = {
  ["blue"] = {Description="Blue", RGB=0x0000FF}
}

for color,val in pairs(table1) do
  table2[color] = table1[color]
  -- or table2[color] = val
end

for color in pairs(table2) do
  print(string.format("%06x - %s", table2[color].RGB, table2[color].Description))
end
```

Here's how the output looks

```text
0000ff - Blue
00ff00 - Green
ff0000 - Red
```

The order in which the colors appear is entirely unpredictable.
