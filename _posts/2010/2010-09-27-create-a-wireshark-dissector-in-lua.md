---
layout: default
title: Create a Wireshark dissector in Lua
tags: wireshark lua dissector programming
comments: true
---
# Create a Wireshark dissector in Lua

You have a custom protocol and would like to give your users the ability to visualize it in Wireshark? If your answer is yes, this post is for you.

I recommend using Wireshark's embedded Lua interpreter, and its [API](https://www.wireshark.org/docs/wsdg_html_chunked/wsluarm_modules.html) for [Lua](http://www.lua.org/pil/). It is the easiest way to prototype dissectors which, for performance reasons, may later be rewritten in C. At the time of writing, I am still using Wireshark 1.2.1, but you might consider using [the latest version](http://www.wireshark.org/download.html).

Let us begin with some sample code.

## Protocol dissector script in Lua

We use a chained dissector. A chained dissector dissects payload of an existing protocol such as payload of a protocol message destined to a particular TCP port. It receives the payload as an input parameter of the dissector function.

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
local tcp_dissector_table = DissectorTable.get("tcp.port")
dissector = tcp_dissector_table:get_dissector(8002)
  -- you can call dissector from function p_myproto.dissector above
  -- so that the previous dissector gets called
tcp_dissector_table:add(8002, p_myproto)
```

## Running the Lua script in Wireshark

These are the steps required to test the code above

1. Edit and save the lua script above to any folder e.g. a file called `myproto.lua` in `c:\myproto`

2. Open `init.lua` in the Wireshark installation directory for editing. You will need Admin privileges on Windows Vista and 7.

3. Ensure that the following line in `init.lua` is commented out - skip step if Wireshark version is 1.4 or better

    ```lua
    -- disable_lua = true; do return end;
    ```

4. Add the following lines to `init.lua` at the very end

    ```lua
    MYPROTO_SCRIPT_PATH="C:\\myproto\\"
    dofile(MYPROTO_SCRIPT_PATH.."myproto.lua")
    ```

5. Change MYPROTO_SCRIPT_PATH to point to the folder where you saved the script in step 1

6. Run Wireshark

7. Load a capture file that has the packets of your custom protocol or start a live capture

Here's a figure that shows the protocol dissector in action

![Wireshark Dissector](/assets/img/wireshark-lua.jpg)
