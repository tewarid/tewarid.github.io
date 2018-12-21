---
layout: default
title: Microsoft.NET vs Java on portability
tags: .net c# java portability
comments: true
---
# Microsoft.NET vs Java on portability

Portability is a much sought after objective of high-level (as opposed to machine-level) languages. Portability reached a water-shed moment with Java, which defined an intermediate language (IL) that programs can be compiled to (called byte code) and a Virtual Machine that executes the IL. By abstracting the machine-level aspects like memory, processor and operating system, Java brought portability to the mainstream.

Earlier attempts at portability in languages like C and C++ were based on being able to compile the same high-level code to different machine-level code, using different compiler implementations for each machine architecture, and portable run-time libraries.

IL code is translated to machine code at run-time. That requires a capable machine. IL code allows access to machine-specific features (like graphics processors) using non-portable extension mechanisms. Java has been relegated to the background in mobile devices due to these factors. Microsoft.NET has however managed to remain relevant by embracing machine-specific extensions.

Microsoft.NET began as a Windows only run-time. Microsoft had the foresight to release its specifications as open standards. Now, due to [Mono](http://www.mono-project.com/What_is_Mono), .NET is available on a number of different machine architectures including ARM, used on most mobile devices, and x86, used on most PCs. It has clearly overtaken Java in that sense. Java is still relevant in the mobile devices space due to Android and that too only as a high-level language. Java is compiled to run on Android's own VM called Dalvik.

Java is however the quintessential portable language on desktop PCs and servers. It will remain relevant there for a long time due to strong backing from the likes of Apache, Google, IBM, Oracle, SAP, and due to the large number of applications and frameworks written in it. Developer usage [trends](https://www.tiobe.com/tiobe-index/) show Java as stagnant, surprising considering Android, but C# and Visual Basic .NET on a steady rise.

I suspect that JavaScript will overtake the incumbents with respect to portability and sheer usage.
