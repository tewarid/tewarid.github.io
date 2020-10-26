---
layout: default
title: How Google Home iOS app configures Wi-Fi on a new smart speaker
tags: google home smart speaker pair wifi protocol bluetooth le
comments: true
---
# How Google Home iOS app configures Wi-Fi on a new smart speaker

Google Home smart speaker devices are setup using the Google Home app on iOS. While on Android this process is mostly seamless to the user, it is somewhat more laborious on iOS.

To begin with, the smart speaker tells the user to download the Google Home app from the App Store.

The app will attempt to find the speaker over Bluetooth, using Bluetooth LE advertisement packets that look as follows

```text
Bluetooth HCI Event - LE Meta
    Event Code: LE Meta (0x3e)
    Parameter Total Length: 36
    Sub Event: LE Advertising Report (0x02)
    Num Reports: 1
    Event Type: Connectable Undirected Advertising (0x00)
    Peer Address Type: Random Device Address (0x01)
    BD_ADDR: 42:82:82:e8:92:a8 (42:82:82:e8:92:a8)
    Data Length: 24
    Advertising Data
        Flags
            Length: 2
            Type: Flags (0x01)
            000. .... = Reserved: 0x0
            ...0 .... = Simultaneous LE and BR/EDR to Same Device Capable (Host): false (0x0)
            .... 0... = Simultaneous LE and BR/EDR to Same Device Capable (Controller): false (0x0)
            .... .0.. = BR/EDR Not Supported: false (0x0)
            .... ..1. = LE General Discoverable Mode: true (0x1)
            .... ...0 = LE Limited Discoverable Mode: false (0x0)
        16-bit Service Class UUIDs
            Length: 3
            Type: 16-bit Service Class UUIDs (0x03)
            UUID 16: Google (0xfea0)
        Service Data - 16 bit UUID
            Length: 16
            Type: Service Data - 16 bit UUID (0x16)
            UUID 16: Google (0xfea0)
            Service Data: 03fa8fca33e25c6b2020203e00
    RSSI: -49dBm
```

Once a speaker is found, a sound is played on it and the app asks the user to confirm that they have heard it. This is probably used to ensure the speaker being configured is the one intended.

Next, the app lists all Wi-Fi networks visible to iOS, asks the user to pick one, and requests a password.

The app sends Wi-Fi configuration over Bluetooth LE, using the GATT services described below. These were discovered using Wireshark from `bluetoothd-hci-latest.pklg` file that is available in iOS's sysdiagnose file.

The following service is used to read the speaker's temporary public key

```text
Service UUID: Google (0xfea0)
Characteristic UUID: 197c6160fab211e49fbb0002a5d5c51b
```

The following service is used to write the Wi-Fi configuration

```text
Service UUID: Google (0xfea0)
Characteristic UUID: 0328fe40002f11e587d00002a5d5c51b
```

Here's how it appears in Wireshark

```text
Bluetooth
PacketLogger Sent ACL Data
Bluetooth HCI ACL Packet
    .... 0000 0100 0001 = Connection Handle: 0x041
    ..00 .... .... .... = PB Flag: First Non-automatically Flushable Packet (0)
    00.. .... .... .... = BC Flag: Point-To-Point (0)
    Data Total Length: 189
    Data
    [Connect in frame: 4347]
    [Disconnect in frame: 7073]
    [Source BD_ADDR: Apple_6c:bb:df (a4:d9:31:6c:bb:df)]
    [Source Device Name: iPhone]
    [Source Role: Unknown (0)]
    [Destination BD_ADDR: 5a:c2:ae:cb:7e:77 (5a:c2:ae:cb:7e:77)]
    [Destination Device Name: GoogleHome3727]
    [Destination Role: Unknown (0)]
    [Current Mode: Unknown (-1)]
Bluetooth L2CAP Protocol
    Length: 185
    CID: Attribute Protocol (0x0004)
Bluetooth Attribute Protocol
    Opcode: Prepare Write Request (0x16)
        0... .... = Authentication Signature: False
        .0.. .... = Command: False
        ..01 0110 = Method: Prepare Write Request (0x16)
    Handle: 0x004e (Google: Unknown)
        [Service UUID: Google (0xfea0)]
        [UUID: 0328fe40002f11e587d00002a5d5c51b]
    Offset: 0
    Value: 7b22656e635f706173737764223a224b43307a582b6c4f66…
```

The message packet is encoded in JSON and looks like

```json
{"enc_passwd":"tt73nJ3oZMHcY\/KdadHK9CAQs7BAjiGunkr25nylWUYSr9PLvV2+SKSMq31WBewChxVDBKVhdhNUd3sPdKeCvVIvgrAswNV0tKRE24e+6k1Q+6g1xwSDzXcfXRJe0EVZY+a\/AVfMpQDUbotha\/U1kQYv8OJ4CtiFsYAlyKDzjSck1fYjF+3vSAm8wcoDFtTc0rrWTtzk6xUavolbAkFyTAbgnG6NkbPqhGoL4XOfZbU\/PKRP7OQy3mxy6FbT0n3SxDhsXPYt8PAdkZWnYRdYdNvzCseEiv\/c9EHiXRzgAWu18TOBUhDMzzCzLfbp8fxZHhAUMn0t9YD1FxWiS9dslw==","wpa_auth":7,"ssid":"Airport Extreme","scan_ssid":1,"wpa_id":0}
```

The Wi-Fi password is sent in encrypted form ensuring it cannot be easily obtained.

The speaker then proceeds to get on to the Wi-Fi network, and the app proceeds with the remaining configuration such as giving a new name to the speaker, and adding it to user's home graph.
