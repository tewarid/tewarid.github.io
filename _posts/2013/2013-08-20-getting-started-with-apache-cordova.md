---
layout: default
title: Getting started with Apache Cordova
tags: apache cordova
comments: true
---
# Getting started with Apache Cordova

Apache Cordova, or PhoneGap, is a cross-platform HTML5 app development framework. It allows creation of offline HTML5 and hybrid applications. This post recounts my brief experience getting started with Apache Cordova. It is relevant for Android and iOS, and assumes you are developing on a Mac.

## Install Node

Grab the [Node](http://nodejs.org/) installer for Mac and install it. You'll need it for installing Cordova. The cordova command line utility is based on Node.

## Install Cordova

After Node has been installed, use npm to install Cordova

```bash
sudo npm -g install cordova
```

Use `cordova --version` to check the version of Cordova. In my case it's currently

```text
3.0.6
```

## Create HTML5 app

A new Cordova HTML5 app can be created as follows

```bash
cordova create myapp com.mycompany.MyApp MyApp
```

A new folder called myapp is created, and the HTML5 resources are created under myapp/www.

## Create platform-specific apps

An iOS app to build and deploy the HTML5 app can be created thus

```bash
cordova platform add ios
```

You'll require Xcode, download it from the Mac App Store if you don't have it installed. The command above does not work with the preview release of Xcode 5.0, I had no problem with Xcode 4.6\. Cordova will create platform-specific files for iOS under myapp/platforms/ios, including a Xcode project to build and deploy the native application. The project opens and builds with the preview version of Xcode 5.

Cordova also copies the HTML5 app from myapp/www to platforms/ios/www. Remember to add the latter folder to .gitignore if you use Git for version control.

To create an application to deploy on Android

```bash
cordova platform add android
```

You'll need to have Android SDK in PATH. Since I use Android Studio, here's how I modified my PATH variable

```bash
export PATH=$PATH:/Applications/Android\ Studio.app/sdk/tools:/Applications/Android\ Studio.app/sdk/platform-tools
```

The Android project structure under myapp/platforms/android does not work with Android Studio, but builds with `ant`. Eclipse ADT can be used to [migrate](http://developer.android.com/sdk/installing/migrate.html) the project to Gradle and Android Studio. A Gradle based build setup is [under consideration](https://issues.apache.org/jira/browse/CB-3445) but may not happen soon.

## Build and test platform-specific apps

The iOS app can be built and deployed using the Xcode project under myapp/platforms/ios.

To build the android app run ant under myapp/platforms/android

```bash
ant debug
```

Deploy using adb

```bash
adb install -r bin/MyApp-debug.apk
```

## Iterate and build

Every time you change the app in myapp/www, you'll need to run

```bash
cordova prepare ios
cordova prepare android
```

Then, perform the platform-specific build steps described earlier.

The performance on iPhone 4S with iOS 7 is quite acceptable. It not as smooth on a Samsung Galaxy S3 (Android 4.2.2). Lesser Android Smartphones may struggle.
