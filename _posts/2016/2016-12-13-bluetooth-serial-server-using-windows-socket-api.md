---
layout: default
title: Bluetooth serial server using Windows socket API
tags: bluetooth socket api windows server serial spp
comments: true
---
# Bluetooth serial server using Windows socket API

This post describes a means to simulate a Bluetooth serial device on Windows. This can be useful to test Bluetooth applications running on Android and Windows, that use a virtual serial port to communicate with devices.

Windows [Bluetooth socket API](https://docs.microsoft.com/en-us/windows/desktop/Bluetooth/bluetooth-programming-with-windows-sockets) can be used to create a server (listener). I use [32feet.NET](https://github.com/inthehand/32feet) here, a neat .NET library layered over the C/C++ socket APIs provided by Microsoft.

Here's how you can create a Bluetooth listener on the primary adapter/radio

```c#
Guid MyServiceUuid = new Guid("{00001101-0000-1000-8000-00805F9B34FB}");
BluetoothListener listener = new BluetoothListener(MyServiceUuid); // Listen on primary radio
listener.Start();
listener.BeginAcceptBluetoothClient(acceptBluetoothClient, null);
```

The acceptBluetoothClient callback will be called when a client connects, and may be implemented as follows

```c#
if (listener == null) return;
client = listener.EndAcceptBluetoothClient(ar);
stream = client.GetStream();
ReadAsync(stream);
```

ReadAsync is an async method that continuously receives data over the Bluetooth socket, and does something useful with it

```c#
byte[] buffer = new byte[100];
while (true)
{
    try
    {
        int length = await stream.ReadAsync(buffer, 0, buffer.Length);
        // do something useful with data in buffer
    }
    catch
    {
        break;
    }
}
```

The application can send data at any time as follows

```c#
stream.WriteAsync(buffer, 0, buffer.Length);
```

As a bonus to the reader who's come this far, the [code](https://github.com/tewarid/dotnet-tools/tree/master/BluetoothSerialServerTool) above is available at GitHub as part of the Bluetooth Serial Server Tool.

![bluetooth-spp-tool.PNG](/assets/img/bt-spp-server-windows.png)
