---
layout: default
title: Android ICS on PandaBoard
tags: aosp ics pandaboard
comments: true
---

PandaBoard has been graced with Android 4 ICS (Ice Cream Sandwich). Thanks to linaro.org it is fairly easy to obtain and try for yourself, their [download](http://www.linaro.org/downloads/) page provides images for different ARM SoC development [boards](https://wiki.linaro.org/Boards) including [PandaBoard](https://en.wikipedia.org/wiki/PandaBoard).

My PandaBoard is a [Rev](http://omappedia.org/wiki/PandaBoard_Revisions) A2\. The Linaro Android image I tested is [11.12](https://releases.linaro.org/archive/11.12/android/images/). You can use [Win32 Disk Imager]({% link _posts/2011/2011-06-27-write-ubuntu-image-file-to-sd-card-on-windows.md %}) to write the pre-built binary to SD card on Windows.

The [staging](https://releases.linaro.org/archive/11.12/android/images/staging-panda/) build boots all right, but I noted the following issues

1. The mouse pointer is jerky in the home screen, indicative of high CPU load.
2. Graphics are slow in the home screen,  graphics acceleration is so not being used. Settings screen is responsive enough as it does not have anything graphically fancy.
3. Wireless LAN does not work.
4. Main menu (launcher) does not work.

A screen capture obtained using the ddms tool of the Android SDK is shown below. A mini-USB cable can be used to connect the PandaBoard to a PC for debugging.

![Android ICS on PandaBoard](/assets/img/android-ics-linaro-pandaboard.png)

The [tracking](https://releases.linaro.org/archive/11.12/android/images/tracking-panda/) build has almost the same issues. With the [landing](https://releases.linaro.org/archive/11.12/android/images/landing-panda/) build, I couldn't get anything beyond an android logo/text. The display needs to be connected to the DVI port, HDMI port does not work.

I'll be anxiously awaiting new updates. I wish I could delve into the source code but I don't have a build machine with the adequate [specs](http://source.android.com/source/initializing.html). Linaro does have daily AOSP build binaries for PandaBoard but the last successful build is almost a month old.

### Gingerbread

The older Linaro [11.11 build](https://releases.linaro.org/archive/11.11/android/leb-panda/) (Android 2.3.7) boots up nicely. The graphics are snappy.

This is what I find noteworthy

1. Nice, high quality display at 1280 x 1024 pixels. I could not obtain a screen capture using the ddms tool of the Android SDK, all I get is a black screen.
2. Wireless and Bluetooth work. File transfer over Bluetooth from an Android Phone works nicely.

These are some of the issues I have observed

1. The default screen off timeout is 1 minute, the OS crashes when that expires. The only way to get back up is by rebooting (Ctrl-Alt-Del) or using the reset button on the board. The screen off timeout can be increased to a maximum of 30 min.
2. No Android marketplace. Amazon marketplace does work, but only for those in the US.
3. The browser crashes a lot.
4. Miss the home button on a real device. The closest I could get was to use the ESC key on the keyboard and the right mouse button. Both seem to indicate "go back". In the browser that means going back to the previous page. Press several times till you are out of the browser.
5. No sound. I connected the HDMI out to a TV. Youtube videos play but without sound. High definition videos do not play, the output appears corrupted.
6. It is possible to plugin a USB webcam and the `dmesg` output shows it has been successfully detected as a `uvcvideo` device but there is no app to do anything with it.
7. The kernel does not have `cdc_ether` modules or RNDIS so any devices that require that will need to compile a custom kernel.
8. USB flash drives are detected correctly but the device file is not created under `/dev` and no mount point is available to access it.
9. VPN does not work. I tried PPTP and L2TP/IPSec with several subscription based VPNs but with no success.

### Conclusions

Things are at an early experimental stage with Android on PandaBoard. Gingerbread is more mature when compared to ICS, but I wouldn't hurry to replace Ubuntu with Android yet, unless I am willing to put in some significant development effort.

I have to really try and build the ICS from [source](http://source.android.com/), check the cool video below. I wish they provided an image to download.

<iframe width="560" height="315" src="https://www.youtube.com/embed/ltbdDSocIJE?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
