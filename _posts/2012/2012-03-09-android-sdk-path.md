---
layout: default
title: Android SDK path
tags: android sdk install path
---

I had a hard time building a Mono for Android project a while back. I thought I should share this.

On building a Mono for Android project using MonoDevelop I got this cryptic error message:

```text
C:\Program Files\MSBuild\Novell\Novell.MonoDroid.Common.targets(2,2): Error: Could not find android.jar for API Level 10\.  This means the Android SDK platform for API Level 10 is not installed.  Either install it in the Android SDK Manager, or change your Mono for Android project to target an API version that is installed. (Hello)
```

Sure, I thought. I'll just fire up the Android SDK Manager and install the Android SDK for version 2.3 (API Level 10). Easier thought than done, it was already installed. The SDK path reported by the SDK Manager was:

```text
C:\Users\dkt\AppData\Local\Xamarin\MonoForAndroid\AndroidSDK\android-sdk-windows
```

It seems the installer for Mono for Android had messed up the Android SDK path, but where? I looked at the build log and that showed me where MonoDevelop was getting its SDK path:

```text
Target _ResolveMonoAndroidSdks:
 Looking for Android SDK..
 Key HKCU\SOFTWARE\Xamarin\MonoAndroid\PrivateAndroidSdkPath not found.
 Key HKCU\SOFTWARE\Android SDK Tools\Path not found.
 Key HKLM\SOFTWARE\Android SDK Tools\Path found:
 Path contains adb.exe in \platform-tools (C:\Program Files\Android\android-sdk).
```

All right, so now I knew that the Android SDK was installed in two different folders. The build problem was easily solved after I changed the registry key at `HKLM\SOFTWARE\Android SDK Tools\Path` to point to the path that the Andoid SDK Manager was reporting.

Now, where was the Android SDK Manager getting its path from? Mono for Android setup added a shortcut to its copy of the Android SDK Manager.
