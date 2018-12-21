---
layout: default
title: Install Firefox in the Android 4.0 emulator
tags: firefox android
comments: true
---
# Install Firefox in the Android 4.0 emulator

I was looking for a browser for Android that had support for WebSockets. I opened an online demo such as the one at [websocket.org](http://www.websocket.org/echo.html) in the default Web Browser on the Android device emulator, and was greeted with a message saying WebSockets are not supported.

Getting Firefox is the easiest since its apk can be downloaded from mozilla.org. Firefox will not run on older Android emulator devices which use the ARM v6 architecture, it currently supports the ARM v7a architecture. As luck would have it that is the architecture used by the Android 4.0 emulator device.

Let's get to installing Firefox. Download the apk for the latest version for Android from [mozilla.org](https://nightly.mozilla.org/). At the time of writing this that happens to be `fennec-10.0.3esr.multi.android-arm.apk`.

Start the Android Emulator for ICS (Android 4.0) using AVD Manager.

## Use adb to install the apk

Run adb with the install option, e.g.

```cmd
\platform-tools\adb.exe install fennec-10.0.3esr.multi.android-arm.apk
```

## Use DDMS to install the apk

Run ddms

```cmd
\tools\ddms.bat
```

Note - If ddms fails to connect to the Emulator try resetting adb from the Actions menu.

Run File Explorer from the Device menu. Push the apk to the emulator into the folder `/mnt/sdcard`. Run the Web Browser in the Emulator. Open url `file:///mnt/sdcard/fennec-10.0.3esr.multi.android-arm.apk`. That should get the installer going.

Unfortunately for me, online websocket demos such as the one at [jimbergman.net](http://jimbergman.net/websocket-web-browser-test/), show that Firefox for Android does not yet support WebSockets.

![Firefox](/assets/img/android-emulator-firefox.jpg)

I got this tip from a colleague, and on further investigation [discovered](https://developer.mozilla.org/en/WebSockets/Writing_WebSocket_client_applications) that Firefox version 6.0 does not have the `WebSocket` class, it has been prefixed and is instead called `MozWebSocket`. [Instantiating](http://stackoverflow.com/questions/6960500/websocket-versions-and-backwards-compatibility) that class should get you going.
