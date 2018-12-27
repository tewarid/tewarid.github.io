---
layout: default
title: Debug Logging in .NET
tags: .net logging programming
comments: true
---
# Debug Logging in .NET

This post provides useful references for tackling debug logging in .NET. It does not delve deeply into any of them.

Most Java developers are familiar with and routinely use [Log4J](http://logging.apache.org/log4j/) from Apache Foundation. In fact, Log4J used to be the single big cause of package incompatibility in the Java world. Several Java libraries have been ported over to the .NET world. Log4J is one of them, its .NET equivalent is [Log4Net](http://logging.apache.org/log4net/).

If your company makes using open source components exceedingly difficult, .NET has the built-in [Debug](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.debug) and [Trace](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.trace) classes in System.Diagnostics package. Use [TraceSwitch](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.traceswitch) to determine log level. Use [TraceListener](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.tracelistener) or any of its subclasses to determine where the log output should go.
