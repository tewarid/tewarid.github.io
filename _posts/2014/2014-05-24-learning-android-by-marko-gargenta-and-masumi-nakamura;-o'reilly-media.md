---
layout: default
title: Learning Android by Marko Gargenta and Masumi Nakamura; O'Reilly Media
tags: book android
comments: true
---

[![](http://akamaicovers.oreilly.com/images/0636920023456/lrg.jpg)](http://shop.oreilly.com/product/0636920023456.do)

Learning Android is a relatively short book that leads you through building a real-world application. It is a book for beginners of Android who want to start building end-to-end applications, now. It does not cover server-side programming, or cloud programming as we're increasingly apt to call it, but reuses existing services developed by the authors.

The books starts with an overview of Android in Chapter 1, with topics such as its history and marketshare. That chapter is followed by a review of Java programming in Chapter 2, which I read because I have been away from Java programming a while.

Chapter 3 provides an overview of Android's architecture. I wasn't aware of the Binder RPC mechanism, that the Bionic libc was implemented to avoid L-GPL licensing restriction of glibc, nor that Dalvik is a [register based](http://markfaction.wordpress.com/2012/07/15/stack-based-vs-register-based-virtual-machine-architecture-and-the-dalvik-vm/) Java virtual machine named after a village in Iceland.

Chapter 4 contains instructions on downloading and installing Java and the Android SDK. The book uses Eclipse IDE in all how-to discussions but does mention Android Studio. Chapter 5 dives into the main building blocks available to developers such as Activities, Intents, Services, Content Providers, Broadcast Receivers, and Application context. The remaining chapters thoroughly explore these building blocks as you build an application called Yamba.

You get introduced to the Yamba application in Chapter 6\. Chapter 7 builds the main user interface using Activities. It also discusses performing tasks in the background using AsyncTask. Chapter 8 delves into composing UI using Fragments. Chapter 9 delves into managing preferences stored in the filesystem. Chapter 10 discusses a background service to refresh data obtained over the internet. Chapter 11 discusses SQLite database and content providers to manage and provide data. Chapter 12 delves into list views and adapters to present large amounts of data efficiently. It also discusses building a landscape version of the Yamba app.

Chapter 13 delves into receiving intents using broadcast receivers to periodically refresh data over the internet and to notify the user. Chapter 14 discusses creating a Widget for the app, that can be placed on the home screen. Chapter 15 delves into accessing data over the internet using HTTP. Chapter 16, the final chapter, shows you how to create live wallpapers and handle user interactions using handlers.

To keep up the pace, I wasn't actually coding the app. Readers who did, have reported inconsistencies in the code. Look at the book's [errata](http://www.oreilly.com/catalog/errata.csp?isbn=0636920023456) page, and report any new problems you encounter. I thank O'Reilly Media for providing me an e-book for review.
