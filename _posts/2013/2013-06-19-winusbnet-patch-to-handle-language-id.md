---
layout: default
title: winusbnet patch to handle language id
tags: winusb .net c# usb programming windows
---

[winusbnet](https://github.com/madwizard-thomas/winusbnet/) throws an exception when reading string descriptors using the WinUsb_GetDescriptor call. Basically, that WinUsb call returns false as it is called with a [Language ID](http://www.usb.org/developers/docs/USB_LANGIDs.pdf) of 0, a reserved value.

### Patch GetStringDescriptor in WinUSBDevice.cs

The `GetStringDescriptor` method does not accept a language ID, so we need to patch it to fix that. That change is reproduced below.

```c#
public string GetStringDescriptor(byte index, ushort languageID)
{
    byte[] buffer = new byte[256];
    uint transfered;
    bool success = WinUsb_GetDescriptor(_winUsbHandle, USB_STRING_DESCRIPTOR_TYPE,
                index, languageID, buffer, (uint)buffer.Length, out transfered);
    if (!success)
        throw APIException.Win32("Failed to get USB string descriptor ("  + index + ").");

    int length = buffer[0] - 2;
    if (length <= 0)
        return null;
    char[] chars = System.Text.Encoding.Unicode.GetChars(buffer, 2, length);
    return new string(chars);
}
```

### Patch GetDeviceDescriptor in USBDevice.cs

Tha patched `GetDeviceDescriptor` queries the available languages by calling `GetStringDescriptor` with an index of 0\. It then uses the first language ID to recover other string descriptors.

<!-- highlight lines 10,11,12,13,14,19,23,27 -->

```c#
private static USBDeviceDescriptor GetDeviceDescriptor(string devicePath)
{
    try
    {
        USBDeviceDescriptor descriptor;
        using (API.WinUSBDevice wuDevice = new API.WinUSBDevice())
        {
            wuDevice.OpenDevice(devicePath);
            API.USB_DEVICE_DESCRIPTOR deviceDesc = wuDevice.GetDeviceDescriptor();
            string q = wuDevice.GetStringDescriptor(0, 0);
            if (q.Length == 0)
                throw new USBException("Failed to get USB string descriptor (0).");
            // TODO: Using the first language id. Need to improve API.
            ushort langID = q[0];
            string manufacturer = null, product = null, serialNumber = null;
            byte idx = 0;
            idx = deviceDesc.iManufacturer;
            if (idx > 0)
                manufacturer = wuDevice.GetStringDescriptor(idx, langID);

            idx = deviceDesc.iProduct;
            if (idx > 0)
                product = wuDevice.GetStringDescriptor(idx, langID);

            idx = deviceDesc.iSerialNumber;
            if (idx > 0)
                serialNumber = wuDevice.GetStringDescriptor(idx, langID);
            descriptor = new USBDeviceDescriptor(devicePath, deviceDesc, manufacturer, product, serialNumber);
        }
        return descriptor;

    }
    catch (API.APIException e)
    {
        throw new USBException("Failed to retrieve device descriptor.", e);
    }
}
```

The patch is available on [GitHub](https://github.com/tewarid/winusbnet/commit/101a1dcc1c6f5a2899bd3530136f2b3b64ac7ae4).
