---
layout: default
title: Communicate with USB device in C# using LibUsbDotNet
tags: libusb .net mono c# macos programming
comments: true
---
# Communicate with USB device in C# using LibUsbDotNet

[LibUsbDotNet](http://sourceforge.net/projects/libusbdotnet/) is a cross-platform library. The source code below has been tested on Mac OS X (version 10.6.8 to be precise) using the Mono .NET run-time. On Linux and Mac LibUsbDotNet requires [libusb](http://www.libusb.org/).

On Mac OS X, you'll need to obtain and build libusb from [source](http://sourceforge.net/projects/libusb/files/libusb-1.0/). Ensure you have downloaded and installed the developer SDK for Mac. To build and install it, execute the following commands from a terminal, in the folder that contains the source of libusb.

```bash
./configure CC="gcc -m32" --prefix=/usr
make
sudo make install
```

The following source code snippet is an example of how to send data to a device. The code itself is a heavily modified version of the Read.Write example that ships with LibUsbDotNet.

```c#
public static UsbDevice MyUsbDevice;

#region SET YOUR USB Vendor and Product ID!

public static UsbDeviceFinder MyUsbFinder =
    new UsbDeviceFinder(0x0000, 0x0000); // specify vendor, product id

#endregion

public static void Main(string[] args)
{
    ErrorCode ec = ErrorCode.None;

    try
    {
        // Find and open the usb device.
        MyUsbDevice = UsbDevice.OpenUsbDevice(MyUsbFinder);

        // If the device is open and ready
        if (MyUsbDevice == null) throw new Exception("Device Not Found.");

        // If this is a "whole" usb device (libusb-win32, linux libusb)
        // it will have an IUsbDevice interface. If not (WinUSB) the
        // variable will be null indicating this is an interface of a
        // device.
        IUsbDevice wholeUsbDevice = MyUsbDevice as IUsbDevice;
        if (!ReferenceEquals(wholeUsbDevice, null))
        {
            // This is a "whole" USB device. Before it can be used,
            // the desired configuration and interface must be selected.

            // Select config
            wholeUsbDevice.SetConfiguration(1);

            // Claim interface
            wholeUsbDevice.ClaimInterface(1);
        }

        // open read endpoint
        UsbEndpointReader reader =
            MyUsbDevice.OpenEndpointReader(ReadEndpointID.Ep02);

        // open write endpoint
        UsbEndpointWriter writer =
            MyUsbDevice.OpenEndpointWriter(WriteEndpointID.Ep03);

        // write data, read data
        int bytesWritten;
        ec = writer.Write (new byte[] { 0x00, 0x00 }, 2000, out bytesWritten); // specify data to send

        if (ec != ErrorCode.None)
            throw new Exception (UsbDevice.LastErrorString);

        byte[] readBuffer = new byte[1024];
        while (ec == ErrorCode.None)
        {
            int bytesRead;

            // If the device hasn't sent data in the last 100 milliseconds,
            // a timeout error (ec = IoTimedOut) will occur.
            ec = reader.Read(readBuffer, 100, out bytesRead);

            if (bytesRead == 0) throw new Exception("No more bytes!");

            // Write that output to the console.
            Console.WriteLine(BitConverter.ToString(readBuffer, 0, bytesRead));
        }

        Console.WriteLine("\r\nDone!\r\n");
    }
    catch (Exception ex)
    {
        Console.WriteLine();
        Console.WriteLine((ec != ErrorCode.None ? ec + ":" : String.Empty) + ex.Message);
    }
    finally
    {
        if (MyUsbDevice != null)
        {
            if (MyUsbDevice.IsOpen)
            {
                // If this is a "whole" usb device (libusb-win32, linux libusb-1.0)
                // it exposes an IUsbDevice interface. If not (WinUSB) the
                // 'wholeUsbDevice' variable will be null indicating this is
                // an interface of a device; it does not require or support
                // configuration and interface selection.
                IUsbDevice wholeUsbDevice = MyUsbDevice as IUsbDevice;
                if (!ReferenceEquals(wholeUsbDevice, null))
                {
                    // Release interface
                    wholeUsbDevice.ReleaseInterface(1);
                }

                MyUsbDevice.Close();
            }
            MyUsbDevice = null;

            // Free usb resources
            UsbDevice.Exit();

        }

        // Wait for user input..
        Console.ReadKey();
    }
}
```

Here's a sample output produced by the code

```text
00-02-00-00-00-00-00-06-00-00-00-07-00-00-00-02-01-01-01
IoTimedOut:No more bytes!
```

The same code should run on Windows and Linux. For more details see the [documentation](http://libusbdotnet.sourceforge.net/V2/Index.html) page of LibUSBDotNet. They have a really nice wizard that can create an INF and installer package for Windows.

If Mono raises a System.DllNotFoundException, you might want to take a look at this [page](http://www.mono-project.com/docs/advanced/pinvoke/dllnotfoundexception/).
