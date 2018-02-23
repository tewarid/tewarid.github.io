---
layout: default
title: Create a Wireshark dissector in Lua
tags: wireshark lua dissector programming
---

You have a custom protocol and would like to give your users the ability to visualize it in Wireshark? If your answer is yes, this post is for you.

I recommend using Wireshark's embedded Lua interpreter, and its [API](https://www.wireshark.org/docs/wsdg_html_chunked/wsluarm_modules.html) for [Lua](http://www.lua.org/pil/). It is the easiest way to prototype dissectors which, for performance reasons, may later be rewritten in C. At the time of writing, I am still using Wireshark 1.2.1, but you might consider using [the latest version](http://www.wireshark.org/download.html).

Let us begin with some sample code.

### Protocol dissector script in Lua

We use a chained dissector. A chained dissector dissects payload of an existing protocol such as payload of a protocol message destined to a particular TCP port. It receives the payload as an input parameter of the dissector function.

{% gist 300cd9b377774598478a5ab852ae4d7e %}

### Running the Lua script in Wireshark

Here are the steps required to get the above code running. Skip step 3 if your Wireshark version is 1.4 or better.

1. Edit and save the lua script above to any folder e.g. a file called `myproto.lua` in `c:\myproto`.

2. Open `init.lua` in the Wireshark installation directory for editing. You will need Admin privileges on Windows Vista and 7.

3. Ensure that the following line in `init.lua`, if present, is commented out

    ```lua
    -- disable_lua = true; do return end;
    ```

4. Add the following lines to `init.lua` at the very end

    ```lua
    MYPROTO_SCRIPT_PATH="C:\\myproto\\"
    dofile(MYPROTO_SCRIPT_PATH.."myproto.lua")
    ```

5. Change MYPROTO_SCRIPT_PATH to point to the folder where you saved the script in step 1.

6. Run Wireshark.

7. Load a capture file that has the packets of your custom protocol or start a live capture.

Here's a figure that shows the protocol dissector in action

![Wireshark Dissector](/assets/img/wireshark-lua.jpg)
