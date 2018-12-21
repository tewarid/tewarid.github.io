---
layout: default
title: Dealing with segmented data in a Wireshark dissector written in Lua
tags: wireshark segmentation tcp lua dissector programming
comments: true
---
# Dealing with segmented data in a Wireshark dissector written in Lua

Protocols based on stream-oriented transport protocols like TCP may get segmented i.e. the PDU boundaries may not be preserved. If you are not familiar with writing dissectors for Wireshark in Lua, read [Create a Wireshark dissector in Lua]({% link _posts/2010/2010-09-27-create-a-wireshark-dissector-in-lua.md %}).

## Protocols based on TCP

You can simply let the TCP dissector [reassemble](http://stackoverflow.com/questions/13138088/how-do-i-reassemble-tcp-packet-in-lua-dissector) segments by telling it how much data the dissector function still needs.

Adding the following logic to the dissector function does the trick. Reading the PDU length field is protocol specific, change it appropriately.

```lua
local i = 0
repeat
    if buf:len() - i >= 2 then  -- change length field size appropriately
        -- we have length field
        i = i + buf(i,2):uint() -- change appropriately
        if i > buf:len() then
            -- we don't have all the data we need yet
            pkt.desegment_len = i - buf:len()
            return
        end
    else
        -- we don't have all of length field yet
        pkt.desegment_len = DESEGMENT_ONE_MORE_SEGMENT
        return
    end
until i >= buf:len()

-- rest of the dissector function remains the same,
-- but uses a repeat / until loop to read all PDUs
```

The TCP dissector calls the dissector function with progressively larger chunks of data taken by aggregating data from the following TCP segments. Once data has been aggregated, your dissector function will proceed as usual.

## Protocols not based on TCP

If your protocol is not based on TCP, you will have to handle segmentation on your own. It bears to keep in mind that Wireshark will call the dissector function for each packet, from first to the last, when you first open a capture file. This knowledge can be used to preprocess each packet, and save some state information such as whether it is segmented or not. If it is segmented, its raw data can be appended to a global byte array. This process will repeat until the whole message is ascertained to have been read. A new Tvb can then be created and used for dissection. The final byte array is saved in state of the last packet in sequence.

```lua
local state = pktState[pkt.number]

if state ~= nil then
    -- we've already processed this packet
    if state.complete == true then
        pkt.info = "Command [complete]"
        buf = ByteArray.tvb(state.buffer, "Complete Command")
    else
        pkt.info = "Command [incomplete]"
        return -- nothing to do
    end
else
    -- first time here, capture file has just been opened?
    state = {}
    if partialBuffer == nil then
        partialBuffer = buf(0):bytes()
    else
        partialBuffer:append(buf(0):bytes())
        buf = ByteArray.tvb(partialBuffer, "Command") -- create new tvb for packet
    end
    local i = 0
    repeat
        if buf:len() - i >= 2 then -- change length field size appropriately
            -- we have length field
            i = i + buf(i,2):uint() -- change appropriately
            if i > buf:len() then
                -- we don't have all the data we need yet
                state.complete = false 
                pktState[pkt.number] = state
                return
            end
        else
            -- we don't have all of length field yet
            state.complete = false 
            pktState[pkt.number] = state
            return
        end
    until i >= buf:len()
    state.complete = true
    state.buffer = partialBuffer
    pktState[pkt.number] = state
    partialBuffer = nil
end

-- perform dissection of buf
```

Remember to initialize `pktState` to an empty table i.e. `{}` in the `init` function. `partialBuffer` is a file local scope variable used in the dissector function.
