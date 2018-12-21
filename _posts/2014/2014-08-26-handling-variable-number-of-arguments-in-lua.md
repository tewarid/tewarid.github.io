---
layout: default
title: Handling variable number of arguments in Lua
tags: lua programming
comments: true
---
# Handling variable number of arguments in Lua

Here's a quick example of how variable number of arguments can be handled in Lua. It has been tested with Lua 5.1 and 5.2.

```lua
function SomeFunction(...)
    local list = {...}
    print(string.format("Received %d arguments:", #list))

    -- print all arguments
    print(...)

    -- print all arguments again using a for loop
    for i = 1, #list, 1 do
        print(list[i])
    end
end

SomeFunction("hello", "world")
```
