---
layout: default
title: Install AOSP build to PandaBoard
tags: aosp android pandaboard install windows
comments: true
---
# Install AOSP build to PandaBoard

This post continues the post on building AOSP for PandaBoard. Read [that post]({% link _posts/2013/2013-05-17-building-android-open-source-project-for-the-pandaboard.md %}), if you haven't already. This post covers installing the AOSP images to PandaBoard. It is much more adventuresome that I initially imagined it would be. The procedure described here, with some variations, is based on instructions in the `device/ti/panda/README` file.

## usbboot

PandaBoard's usbboot boot loader runs when no SD card is provided. In this mode, the board can receive the next stage boot loader over the USB bus, using the [usbboot](https://github.com/swetland/omap4boot) utility located under `device/ti/panda`. Unfortunately, VirtualBox Ubuntu VM is able to use the PandaBoard only after Windows host has loaded a valid driver for it. I [modified](https://github.com/tewarid/pandaboard-usb-driver) Google's USB driver to work with PandaBoard's usbboot mode.

I am using Windows 8 as the host OS. It will not install unsigned drivers by default. I test signed the driver using Windows Driver Kit. Once the driver is installed, you'll [need to](http://forum.xda-developers.com/showthread.php?t=570452g) stop the VM, and edit its settings to use device "PandaBoard UsbBoot Interface". You'll know VirtualBox is using the USB device when `lsusb` lists it, and it does not appear in Windows Device Manager on the host. The same driver also works with Android's `fastboot` mode. Here's what `lsusb -v` dumps when PandaBoard is in usbboot mode.

```text
Bus 001 Device 012: ID 0451:d00f Texas Instruments, Inc.
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.10
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0451 Texas Instruments, Inc.
  idProduct          0xd00f
  bcdDevice            0.00
  iManufacturer          33
  iProduct               37
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1
    bmAttributes         0xc0
      Self Powered
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              2
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
```

Finally, here's the command you need to run so that usbboot puts PandaBoard in fastboot mode.

```bash
sudo ./device/ti/panda/usbboot device/ti/panda/bootloader.bin
```

## fastboot

Android's `fastboot` command line utility can flash Android to a device when it is in fastboot mode. Build of `fastboot` from source under `out/host/linux-x86/bin` didn't work, until I installed the Oracle VM VirtualBox Extension Pack and enabled USB 2.0 support. If you want to avoid installing that extension pack, Android SDK for Windows installs `fastboot` in the `platform-tools` folder. You can use that instead of using the one built from source.

You'll need to copy all image files built by `make` under `out/target/product/panda` to the Windows host and run the following commands from the command prompt. Change `ANDROID_SDK_PATH` appropriately.

```cmd
set ANDROID_SDK_PATH=C:\Users\user\AppData\Local\Android\android-sdk
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe oem format
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe flash xloader xloader.bin
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe flash bootloader bootloader.bin
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe erase cache
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe -p panda flash userdata userdata.img
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe -p panda flash boot boot.img
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe -p panda flash system system.img
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe -p panda flash recovery recovery.img
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe -p panda flash cache cache.img
```

The more convenient `flashall` option of `fastboot` fails as follows

```cmd
%ANDROID_SDK_PATH%\platform-tools\fastboot.exe -p panda flashall
error: could not load android-info.txt: No error
```

Hence, the need to flash image files individually.

At this point, you can reset the PandaBoard so that it loads Android!

To boot into fastboot mode ever again, hold the GPIO_121 button (furthest button from SD card) and press and release the PWRON_RESET button. Release the GPIO_121 button after a while.

## Proprietary binaries for PowerVR

Android failed to load on PandaBoard after my first build. The serial port console printed the following message.

```text
[  297.078613] PVR_K:(Error): BridgedDispatchKM: Driver initialisation not completed yet. [4836, drivers/gpu/pvr/bridged_pvr_bridge.c]
```

I [discovered](https://groups.google.com/forum/?fromgroups#!topic/android-building/feACaqANrAs) the version of the PowerVR binary required by my Android branch is as follows.

```bash
shell@android:/ $ cat /proc/pvr/version
Version CustomerGoogle_Android_ogles1_ogles2_GPL sgxddk 18 1.8@785978 (release) omap4430_android
System Version String: None

shell@android:/ $ ls -l system/vendor/lib/egl
-rw-r--r-- root     root         4812 2013-05-24 17:25 libEGL_POWERVR_SGX540_120.so
-rw-r--r-- root     root       445892 2013-05-24 17:25 libGLESv1_CM_POWERVR_SGX540_120.so
-rw-r--r-- root     root       371532 2013-05-24 17:25 libGLESv2_POWERVR_SGX540_120.so
```

The binary I had provided pre build was a different version.

```bash
$ strings vendor/imgtec/panda/proprietary/libGLESv2_POWERVR_SGX540_120.so | grep build
OpenGL ES 2.0 build 1.8@905891
OpenGL ES GLSL ES 1.00 build 1.8@905891
```

The solution was to clobber and build again with the [correct version](https://dl.google.com/dl/android/aosp/imgtec-panda-20120430-67545da7.tgz) of the proprietary driver.

## Does it work?

This Android build is painfully slow. `adb shell dmesg` shows repeating `omapfb` message below.

```cmd
%ANDROID_SDK_PATH%\platform-tools\adb.exe shell dmesg
...
[   10.060485] omapfb omapfb: Unknown ioctl 0x40044f40
```

The CPU itself is relatively idle as reported by `monitor` and shown in the figure below. Changing display size using `adb am display-size` or display density using `adb am display-density`, has no noticeable impact.

![monitor](/assets/img/android-debug-monitor.jpg)

`logcat` shows the following messages repeating very often.

```text
01-02 15:22:48.375: I/PowerManagerService(346): Going to sleep due to screen timeout...
01-02 15:22:48.382: E/SurfaceFlinger(99): eventControl(0, 1) failed Invalid argument
01-02 15:22:49.390: W/SurfaceFlinger(99): Timed out waiting for hw vsync; faking it
01-02 15:22:53.375: I/PowerManagerService(346): Waking up from sleep...
```

All that leads me to believe graphics are hardware accelerated but buggy. If and when I figure this out I'll post an update.

Here's the Android screen captured using `monitor` on Windows

![Android 4.2.2](/assets/img/android-aosp-pandaboard.jpg)

Enjoy!
