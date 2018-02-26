---
layout: default
title: Log all CLR exceptions using WinDbg
tags: windbg post mortem 
---

This is a short post to complement my earlier post regarding [post-mortem debugging]({% link _posts/2010/2010-09-10-post-mortem-debugging-of-.net-applications-using-windbg.md %}). Sometimes, an application or service crashes without giving us an opportunity to save a detailed memory dump. In such a scenario, it may be useful to run WinDbg, attach to the process of the application or service, and log all exceptions that occur.

To log an exception (handled or not) and continue process execution use the following command in WinDbg

```text
sxe -c "!pe;!clrstack;gc" clr
```

Please see [this article](https://blogs.msdn.com/b/kristoffer/archive/2007/01/03/debugging-exceptions-in-managed-code-using-windbg.aspx) for more details.
