---
layout: default
title: Post-mortem debugging of .NET applications using WinDbg
tags: post mortem debug c# .net windows
---

Debugging is a skill you learn under pressure, because you usually learn it when things are going awry with a particular application or service just gone live, and you are quite convinced it has no severe bugs. It is never a pleasure to encounter such bugs, because although they happen quite frequently in your production environment, they are particularly hard to reproduce in your development or test environment.

For managed applications, you can learn a new skill that will save you some face, it is called post-mortem debugging. WinDbg is a splendid tool. It can be used to debug any arbitrary running process, but it is a really useful tool for debugging memory dumps.

Process memory can be dumped quite easily

* You can use WinDbg

    [Install](http://www.microsoft.com/whdc/devtools/debugging/installx86.mspx) WinDbg, attach to a process, break on the required exception and then dump memory. Memory can be dumped from the command line or the file menu. From the command line, just type: `.dump /ma filename.dmp`. You need to have enough disk space because `dmp` files can be rather big.

* You can dump process memory using the Task Manager

There are several other ways that are already documented [elsewhere](http://www.wintellect.com/CS/blogs/jrobbins/archive/2010/06/17/how-to-capture-a-minidump-let-me-count-the-ways.aspx), but for most purposes the above should suffice.

Once you have the dump file, you can open it with WinDbg.

There are several useful commands you can then execute to examine the process

* `!runaway`

    Shows thread times. This can be really useful to find badly behaved threads that are consuming much CPU.

* `!analyze -v`

    Shows detailed information about the current exception.

* `!threads`

    Shows a list of threads currently in execution.

* `!uniqstack`

    Displays all stacks of all the threads of the current process. You can also see the stack trace of a single thread using the [`k`](http://msdn.microsoft.com/en-us/library/ff551943.aspx) commands.

* `~ns`

    Sets the thread with ID `n` as the current thread.

WinDbg is most useful for debugging managed application using the following extensions

* [SOS](http://msdn.microsoft.com/en-us/library/bb190764.aspx)

    This extension is distributed along with the .NET framework can be loaded using the following command: `.loadby sos mscorwks` or `.loadby sos clr` for .NET 4.

* [SOSEX](http://www.stevestechspot.com/default.aspx)

    This has several useful additions to the core SOS extension. It must be loaded by using the `.load` command e.g. `.load c:\sosex\sosex.dll`.

* [Psscor2](https://blogs.msdn.microsoft.com/amb/2011/04/28/free-download-psscor2-new-windbg-extension-for-debugging-net-4-0-applications/)

    Has several useful commands, especially commands for debugging ASP.NET applications. Load it using the `.load` command e.g. `.load c:\psscor2\x86\psscor2.dll`.

The SOS extension has several useful commands, particularly

* `!clrstack -p`

    Prints the stack trace of the current thread. This only works for managed threads. If you have [symbols](http://support.microsoft.com/kb/311503) for your assemblies, you can see some pretty detailed information in the stack trace.

* `!dumpheap`

    Dumps the objects from the heap. You can dump objects of a specific type by using the -type option e.g. `!dumpheap -type System.Threading.Thread`. This can be really useful to list all objects and their addresses. By knowing the number of objects of a particular type in use you can debug typical resource exhaustion problems.

* `!do address`

    Dumps information about the object at the address specified. Value of primitive fields of the object are displayed and other references can be further examined using this command.

* `!da`

    Prints information about an array

The SOSEX extension has the following commands that are particularly useful

* `!refs`

    Prints all objects that reference the object specified.

* `!dlk`

    Searches for possible deadlocks.

The Psscor2 extension has one particularly useful command, among several others, that can come in handy when troubleshooting network related issues

* `!PrintIPAddress`

    Prints the IP address of the specified [IPAddress](http://msdn.microsoft.com/en-us/library/system.net.ipaddress.aspx) instance.

This short post is meant to whet your appetite for post-mortem debugging and to point you in the right direction.

Enjoy!
