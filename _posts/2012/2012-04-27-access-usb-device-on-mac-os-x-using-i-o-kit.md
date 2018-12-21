---
layout: default
title: Access USB device on Mac OS X using I/O Kit
tags: macos usb bulk transfer c
comments: true
---
# Access USB device on Mac OS X using I/O Kit

This post shows how you can access a USB device from user space on Mac OS X. I used Xcode 4.3.2 on Mac OS X Lion (10.7.3) for testing the code.

Apple provides the [USB Device Interface Guide](https://developer.apple.com/library/mac/documentation/devicedrivers/Conceptual/USBBook/WorkingWithUSB.pdf "USB Device Interface Guide") that shows how USB devices can be accessed from user space. The book [OS X and iOS Kernel Programming](http://www.apress.com/gp/book/9781430235361) is also very helpful, see Chapter 15 - User-Space USB Drivers.

Create an Xcode console application.

Add the following libraries to the default target

* IOKit.framework
* CoreFoundation.framework

Xcode will have created `main.c`, add the following headers

```c
#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>
#include <IOKit/usb/USBSpec.h>
```

Let's now implement the main function. Add the following variable declarations.

```c
CFMutableDictionaryRef matchingDictionary = NULL;
SInt32 idVendor = 0x0000; // set vendor id
SInt32 idProduct = 0x0000; // set product id
io_iterator_t iterator = 0;
io_service_t usbRef;
SInt32 score;
IOCFPlugInInterface** plugin;
IOUSBDeviceInterface300** usbDevice = NULL;
IOReturn ret;
IOUSBConfigurationDescriptorPtr config;
IOUSBFindInterfaceRequest interfaceRequest;
IOUSBInterfaceInterface300** usbInterface;
char out[] = { 0x00, 0x00 }; // set data to send
char* in;
UInt32 numBytes;
```

We now try to find the USB device using the vendor and product id

```c
matchingDictionary = IOServiceMatching(kIOUSBDeviceClassName);
CFDictionaryAddValue(matchingDictionary,
                        CFSTR(kUSBVendorID),
                        CFNumberCreate(kCFAllocatorDefault,
                                    kCFNumberSInt32Type, &idVendor));
CFDictionaryAddValue(matchingDictionary,
                        CFSTR(kUSBProductID),
                        CFNumberCreate(kCFAllocatorDefault,
                                    kCFNumberSInt32Type, &idProduct));
IOServiceGetMatchingServices(kIOMasterPortDefault,
                                matchingDictionary, &iterator);
usbRef = IOIteratorNext(iterator);
if (usbRef == 0)
{
    printf("Device not found\n");
    return -1;
}
IOObjectRelease(iterator);
IOCreatePlugInInterfaceForService(usbRef, kIOUSBDeviceUserClientTypeID,
                                    kIOCFPlugInInterfaceID, &plugin, &score);
IOObjectRelease(usbRef);
(*plugin)->QueryInterface(plugin,
                            CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID300),
                            (LPVOID)&usbDevice);
(*plugin)->Release(plugin);
```

Now that we have found the device, we open the device and set the first configuration as active

```c
ret = (*usbDevice)->USBDeviceOpen(usbDevice);
if (ret == kIOReturnSuccess)
{
    // set first configuration as active
    ret = (*usbDevice)->GetConfigurationDescriptorPtr(usbDevice, 0, &config);
    if (ret != kIOReturnSuccess)
    {
        printf("Could not set active configuration (error: %x)\n", ret);
        return -1;
    }
    (*usbDevice)->SetConfiguration(usbDevice, config->bConfigurationValue);
}
else if (ret == kIOReturnExclusiveAccess)
{
    // this is not a problem as we can still do some things
}
else
{
    printf("Could not open device (error: %x)\n", ret);
    return -1;
}
```

Having done that, we need to find the interface we want to use for sending and receiving data. Our device is a USB RNDIS device that has two bulk data endpoints on the second interface (#1).

```c
interfaceRequest.bInterfaceClass = kIOUSBFindInterfaceDontCare;
interfaceRequest.bInterfaceSubClass = kIOUSBFindInterfaceDontCare;
interfaceRequest.bInterfaceProtocol = kIOUSBFindInterfaceDontCare;
interfaceRequest.bAlternateSetting = kIOUSBFindInterfaceDontCare;
(*usbDevice)->CreateInterfaceIterator(usbDevice,
                                        &interfaceRequest, &iterator);
IOIteratorNext(iterator); // skip interface #0
usbRef = IOIteratorNext(iterator);
IOObjectRelease(iterator);
IOCreatePlugInInterfaceForService(usbRef,
                                    kIOUSBInterfaceUserClientTypeID,
                                    kIOCFPlugInInterfaceID, &plugin, &score);
IOObjectRelease(usbRef);
(*plugin)->QueryInterface(plugin,
                            CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID300),
                            (LPVOID)&usbInterface);
(*plugin)->Release(plugin);
```

Now that we have found the interface, let us open it

```c
ret = (*usbInterface)->USBInterfaceOpen(usbInterface);
if (ret != kIOReturnSuccess)
{
    printf("Could not open interface (error: %x)\n", ret);
    return -1;
}
```

Finally, we can send and receive some data. The pipe references are in the same order as the end points that appear in the Bus Probe tab of USB Prober. In our case, pipe 0 is the default control endpoint (does not have an endpoint descriptor and will not appear in USB Prober), pipe 1 is the bulk data output endpoint, and pipe 2 is the bulk data input endpoint.

For some reason, if we read less than 64 bytes I/O Kit returns a kIOReturnOverrun error. Coincidentally, the max packet size of the bulk input pipe of the device is also 64 bytes.

```c
// Send data through pipe 1
(*usbInterface)->WritePipe(usbInterface, 1, out, sizeof(out));

// Read data through pipe 2
numBytes = 64;
in = malloc(numBytes);
ret = (*usbInterface)->ReadPipe(usbInterface, 2, in, &numBytes);
if (ret == kIOReturnSuccess)
{
    printf("Read %d bytes\n", numBytes);
}
else
{
    printf("Read failed (error: %x)\n", ret);
}
```

To wrap it all, we close the interface and device, and return from main

```c
(*usbInterface)->USBInterfaceClose(usbInterface);
(*usbDevice)->USBDeviceClose(usbDevice);

return 0;
```
