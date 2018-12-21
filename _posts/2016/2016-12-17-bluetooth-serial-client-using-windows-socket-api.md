---
layout: default
title: Bluetooth serial client using Windows socket API
tags: bluetooth serial client windows spp socket
comments: true
---
# Bluetooth serial client using Windows socket API

This post shows how you can discover paired Bluetooth devices, and communicate with them, using Windows socket API. The Windows socket API is available in .NET through the excellent [32feet.NET](https://www.nuget.org/packages/32feet.NET/) library.

This is how you can discover Bluetooth devices paired with Windows

```c#
client = new BluetoothClient();
devices = client.DiscoverDevices(10, true, true, false);
```

This is how you can connect with a device, and obtain a NetworkStream to read from

```c#
Guid MyServiceUuid = new Guid("{00001101-0000-1000-8000-00805F9B34FB}");
client.Connect(devices[0].DeviceAddress, MyServiceUuid);
NetworkStream stream = client.GetStream();
ReadAsync(stream);
```

Here's the implementation of ReadAsync

```c#
byte[] buffer = new byte[100];
while (true)
{
    try
    {
        int length = await stream.ReadAsync(buffer, 0, buffer.Length);
        // do something with buffer
    }
    catch
    {
        break;
    }
}
```

The application can send data at any time as follows

```c#
stream.Write(buffer, 0, buffer.Length);
```

The code above is available at GitHub as part of the [Bluetooth Serial Client Tool](https://github.com/tewarid/net-tools/blob/master/BluetoothSerialClientTool).

![bluetooth-serial-client-tool.PNG](/assets/img/bt-spp-client-windows.png)
