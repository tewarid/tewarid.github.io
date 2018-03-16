---
layout: default
title: Embedding the Browser
tags: browser component embed
comments: true
---

This post discusses different options to embed the web browser into an app, on different platforms.

Most applications can benefit from using HTML for the User Interface (UI). HTML has evolved to a point where it is easier to make better UI using it, than using native UI toolkits. The UI is also much more portable, if you need to support different form factors and platforms.

Portability is achieved using JavaScript and CSS, but you have to take browser-specific nuances into account. Several open source JavaScript UI libraries have evolved over the past years, such as [Bootstrap](http://twitter.github.io/bootstrap/), [Dojo Toolkit](http://dojotoolkit.org/), [Ext JS](http://www.sencha.com/products/extjs/) (GPL), and [JQuery UI](http://jqueryui.com/), that ease the pain of cross-browser UI development. There is also a plethora of open source and commercial cross-platform toolkits that leverage HTML5 such as [Appcelerator Titanium](http://www.appcelerator.com/platform/titanium-sdk), [PhoneGap](http://phonegap.com/), [Rhodes](https://github.com/rhomobile/rhodes), and [Sencha Touch](http://www.sencha.com/products/touch/) (GPL).

The limitations of such an approach is performance, but even that is slowly ceasing to be a problem as browsers gain from hardware acceleration. Another drawback is lack of proper tools for editing, debugging and profiling. Fortunately, browsers such as Chrome and FireFox now have good built-in tools or extensions that can be of help. [IDE support]({% link _posts/2012/2012-07-11-jetbrains-webstorm.md %}) is also constantly evolving with features such as code completion, JavaScript debugging, refactoring, and static code analysis.

### Windows desktop

On the desktop, if you are a .NET programmer you can use the [WebBrowser](http://msdn.microsoft.com/en-us/library/system.windows.forms.webbrowser.aspx) class. The benefit of that class is its ease of use, but the drawback is that the browser is essentially Internet Explorer (IE). IE is not known to have stellar support for evolving web standards. One particular problem I faced was the browser control not applying [print](http://coding.smashingmagazine.com/2011/11/24/how-to-set-up-a-print-style-sheet/) media CSS correctly.

There is further effort from the open source community to provide browser controls based on [Chromium](http://code.google.com/p/chromiumembedded/), [Gecko](http://code.google.com/p/geckofx/), and [WebKit](http://code.google.com/p/geckofx/) that may have better standards support.

The advantage of using the WebBrowser class is that you can use its [ObjectForScripting property](http://msdn.microsoft.com/en-us/library/system.windows.forms.webbrowser.objectforscripting.aspx) to set an object that can be accessed from JavaScript using the window.external object. You can encapsulate this proprietary mechanism behind a JavaScript class/interface for better portability, and switch to another implementation on a different platform.

### Java

The Java platform has the `javax.swing.JEditorPane` component that can be used to show and edit HTML, but it is not a viable alternative for modern web user interface development. A more modern cross-platform alternative may be the [`javafx.scene.web.WebEngine`](http://docs.oracle.com/javafx/2/webview/WebViewSample.java.htm) component.

Some may find Eclipse SWT's `org.eclipse.swt.browser.Browser` to be a better alternative as it embeds the default browser of the OS e.g. Internet Explorer on Windows.

### Android

Embedding the browser in Android and iOS is a breeze. If you are developing an Android app in Java, the [WebView](http://developer.android.com/reference/android/webkit/WebView.html) class in Android can be used to embed the browser. If you are a .NET programmer and have adopted Mono for Android, you can use a similar class from their [.NET wrapper API for Android](http://androidapi.xamarin.com/). It is possible for your JavaScript code to call Java or .NET code by injecting an object using the addJavascriptInterface method of WebView. Form submissions can also be intercepted by creating and setting a WebViewClient subclass.

The Android browser is not known to have good performance, especially for JavaScript. The plethora of Android devices with low-end specs also does not contribute to good performance from the browser.

### iOS

You can embed the browser in an iOS app using the [UIWebView](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIWebView_Class/) class. JavaScript code can be called using the stringByEvaluatingJavaScriptFromString method, but JavaScript cannot call Objective C code. You can always embed a [web server](https://github.com/robbiehanson/CocoaHTTPServer) in your app, that the UI can call.
