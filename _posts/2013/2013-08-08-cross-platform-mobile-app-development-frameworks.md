---
layout: default
title: Cross-platform mobile app development frameworks
tags: cross platform app development
comments: true
---
# Cross-platform mobile app development frameworks

Development of native applications for all the different mobile devices out there is becoming increasingly costly&mdash;especially for small teams. Reusing widespread knowledge of web app development to develop mobile apps is an attractive proposition.

A brief survey of cross-platform mobile app development frameworks follows. Which of these to choose for your next project is quite a tough choice. I have been in hybrid app development situations and the truth is you always run into limitations. You will have to troubleshoot corner cases, performance issues, and go native when nothing else works. Do choose an approach that gives you that flexibility.

## Cordova by Apache

* App runs in embedded web browser i.e. you code in HTML5 and CSS3
* Ability to create plug-ins to invoke native code, including UI
* Code is developed and packaged using IDE of native platform, such as Android Studio and Xcode
* Could become extinct after [Web Applications](http://www.w3.org/2008/webapps/) are implemented by most browsers
* See [PhoneGap: a misunderstood hybrid framework](http://www.asyncdev.net/2012/10/phonegap-a-misunderstood-hybrid-framework/) for more

## RhoMobile by Zebra

* Provides a [Ruby on Rails](http://rubyonrails.org/) like framework
* UI views are written in HTML5
* Controller and model written in Ruby
* Ruby code executes in an embedded web server
* Code is written in [RhoStudio](https://github.com/rhomobile/rhostudio)
* Native extensions can be written for scenarios that require more performance or access to device specific features

## Sencha Touch _[defunct]_

* Entirely HTML5 based
* Lots of UI components
* Applications can be served over the Internet
* Ability to package apps for distribution through app stores
* Mobile (touch) centric
* Not very different from AngularJS, Bootstrap, Dojo Toolkit, Ext.js, jQuery Mobile etc

## Titanium by Appcelerator

* Code that will be reused is written in JavaScript
* JavaScript is evaluated at run-time, using V8 or Rhino, like Node.js
* JavaScript code can call native code and vice-versa through proxy objects
* Code can use native embedded browser to create hybrid apps
* Code is developed in [Titanium Studio](http://www.appcelerator.com/platform/titanium-studio/), an Eclipse-based IDE
* Also see [Comparing Titanium and PhoneGap](http://www.appcelerator.com/blog/2012/05/comparing-titanium-and-phonegap/)

## Worklight by IBM _[defunct]_

* End-to-end solution with server and client frameworks
* Hybrid application coded using HTML5 and CSS3
* Development environment based on Eclipse
* Support for jQuery Mobile, Sencha Touch, and Dojo Mobile
* Application can be prepared for deployment to several native platforms, without changing any code
* Concept of a Shell app, which provides integration to the native platform by leveraging Apache Cordova
* Hybrid inner apps run within the shell app and are managed by the server
* Server can be used to preview and manage applications (app store)
* Offerings for enterprise and consumer space

## Xamarin by Microsoft

* Application has access to the [Mono](http://mono-project.com/) .NET runtime features, including its core class library for .NET
* Wraps native UI of the device. UI views retain native look-and-feel but cannot be reused across different platforms
* Core application logic can be reused
* Apps are distributed as ARM binaries, with native performance
* Code can be developed in Xamarin Studio or Visual Studio (paid version required)
* Up front licensing cost justifiable if you are a Microsoft developer and can reuse most code except UI views

There are many other lesser-used cross-platform frameworks such as [Calatrava](http://calatrava.github.io/) from the folks at ThoughtWorks, [Corona SDK](http://www.coronalabs.com/) Lua-based framework for 2D games, and [Icenium](http://www.icenium.com/) _[defunct]_.
