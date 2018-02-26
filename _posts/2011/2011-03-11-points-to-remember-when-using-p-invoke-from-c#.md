---
layout: default
title: Points to remember when using p/invoke from C#
tags: pinvoke c# .net
---

This blog post tries to capture some essential points to remember when using p/invoke from C#.

### C++

You can expose static methods of a C++ class using the __declspec(dllexport) modifier. The C++ compiler adds each method to the exports table of a DLL with a different name. Use the [dumpbin](http://support.microsoft.com/kb/177429) utility (distributed with Visual Studio) to get the exported name of a method and add an [EntryPoint](http://msdn.microsoft.com/en-us/library/aa288468.aspx#pinvoke_callingdllexport) field to the DllImport attribute. [Dependency Walker](http://www.dependencywalker.com/) is another good tool that shows the exports.

### Calling conventions

Read this [article](http://www.codeproject.com/KB/cpp/calling_conventions_demystified.aspx) that describes the different calling conventions in great detail. If you haven't added calling conventions in your VC++ code, by using either __stdcall or __cdecl, or by changing the [compiler setting](http://msdn.microsoft.com/en-us/library/46t77ak2.aspx), you should remember to set the [CallingConvention field](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.dllimportattribute.callingconvention.aspx) in the DllImport Attribute to [CallingConvention.Cdecl](http://msdn.microsoft.com/en-us/library/system.runtime.interopservices.callingconvention.aspx).

### Callback using delegates

I refer you to this [article](http://blogs.msdn.com/b/thottams/archive/2007/06/02/pinvoke-reverse-pinvoke-and-stdcall-cdecl.aspx) that demonstrates passing delegates. In particular, it shows the right calling convention for .NET delegates i.e. __stdcall. If you have only the binaries for a DLL, you can tell C# to use CallingConvention.Cdecl using the UnmanagedFunctionPointerAttribute for the delegate. Note that you need to create a new instance of the delegate and pass that in your p/invoke call. Passing the method name can lead to a hard to decipher System.AccessViolationException.

### Marshalling or type mapping

This [article](http://www.codeproject.com/KB/cs/essentialpinvoke.aspx) has a table of type mappings and other tips regarding marshalling. In case you need to pass or receive an array of bytes (char* in C or C++) or any opaque pointer, the [IntPtr](http://msdn.microsoft.com/en-us/library/system.intptr.aspx) structure can be used. Use the [Copy](http://msdn.microsoft.com/en-us/library/ms146625.aspx) method from the [System.Runtime.InteropServices.Marshal](http://msdn.microsoft.com/en-us/library/asx0thw2.aspx) class to recover data as an array of bytes.

### Tools

[SWIG](http://www.swig.org/) can generate C# code that wraps any C/C++ header.

[P/Invoke Interop Assistant](http://blogs.msdn.com/b/bclteam/archive/2008/06/23/p-invoke-interop-assistant-justin-van-patten.aspx) automatically generates C# p/invoke declarations for type and function declarations in C and C++.

Red Gate has a [free plugin](https://www.red-gate.com/products/dotnet-development/pinvoke/) for Visual Studio that can help you to find and contribute p/invoke signatures for well known APIs.
