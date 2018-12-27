---
layout: default
title: Points to remember when using p/invoke from C#
tags: pinvoke c# .net
comments: true
---
# Points to remember when using p/invoke from C#

This blog post tries to capture some essential points to remember when using p/invoke from C#.

## C++

You can expose static methods of a C++ class using the __declspec(dllexport) modifier. The C++ compiler adds each method to the exports table of a DLL with a different name. Use the [dumpbin](http://support.microsoft.com/kb/177429) utility (distributed with Visual Studio) to get the exported name of a method and add an [EntryPoint](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.dllimportattribute.entrypoint) field to the `DllImport` attribute. [Dependency Walker](http://www.dependencywalker.com/) is another good tool that shows the exports.

## Marshalling or type mapping

[Essential P/Invoke](https://www.codeproject.com/Articles/12121/Essential-P-Invoke) has a table of type mappings and other tips regarding marshalling. In case you need to pass, or receive, an array of bytes&mdash;`char*` in C or C++&mdash;or any opaque pointer, the [IntPtrhttps://docs.microsoft.com/en-us/dotnet/api/system.intptr) structure can be used. Use the [Copy](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal.copy) method from the [System.Runtime.InteropServices.Marshal](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal) class to recover data as an array of bytes.

## Calling conventions

[Calling Conventions Demystified](https://www.codeproject.com/Articles/1388/Calling-Conventions-Demystified) describes the different calling conventions in great detail. If you haven't specified conventions in your Visual C++ code, either by using `__stdcall` or `__cdecl`, or by changing the [compiler setting](https://docs.microsoft.com/en-us/cpp/build/reference/gd-gr-gv-gz-calling-convention), you should remember to set the [CallingConvention field](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.dllimportattribute.callingconvention) in the `DllImport` Attribute to `CallingConvention.Cdecl`.

## Callback using delegates

[PInvoke-Reverse PInvoke and __stdcall – __cdecl](https://blogs.msdn.microsoft.com/thottams/2007/06/02/pinvoke-reverse-pinvoke-and-__stdcall-__cdecl/) demonstrates passing delegates. In particular, it shows the right calling convention for .NET delegates&mdash;`__stdcall`. You can tell C# to use `CallingConvention.Cdecl` using the `UnmanagedFunctionPointer` attribute. You need to create a new instance of the delegate and pass that in your p/invoke call. Passing just the method name can lead to a hard to decipher `System.AccessViolationException`.

## Useful tools

[SWIG](http://www.swig.org/) can generate C# code that wraps any C/C++ header.

[P/Invoke Interop Assistant](https://blogs.msdn.microsoft.com/bclteam/2008/06/23/pinvoke-interop-assistant-justin-van-patten/) automatically generates C# p/invoke declarations for type and function declarations in C and C++.

Redgate has a [free plugin](https://pinvoke.net) for Visual Studio that can help you to find and contribute p/invoke signatures for well known APIs.
