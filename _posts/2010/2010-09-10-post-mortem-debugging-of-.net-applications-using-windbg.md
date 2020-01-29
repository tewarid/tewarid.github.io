---
layout: default
title: Post-mortem debugging of .NET applications using WinDbg
tags: post mortem debug c# .net windows
comments: true
---
# Post-mortem debugging of .NET applications using WinDbg

Debugging is a skill you usually learn under pressure, when things are going awry with an application or service just gone live. It is never a pleasure to encounter such bugs because, although they happen quite frequently in your production environment, they are particularly hard to reproduce in your test environment.

For managed applications, you can learn a new skill that will save you some face, called post-mortem debugging. [WinDbg](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools) is a splendid tool that is often used to debug running processes, but can also be used to analyze process crash dumps.

## Dump process memory

User mode process memory dumps can be obtained through several means

* Windows Error Reporting (WER)

    Configure WER to [dump process memory when a user mode application crashes](https://docs.microsoft.com/en-us/windows/win32/wer/collecting-user-mode-dumps).

* Task Manager

    Right click on a process and select _Create dump file_. 32-bit Task Manager at %WINDIR%\SysWOW64\Taskmgr.exe should be used to dump memory of a 32-bit process.

* WinDbg

    Attach to a process and dump memory from the _File_ menu, or the command line

    ```text
    .dump /ma filename.dmp
    ```

You need to have enough disk space because `dmp` files can be rather big.

## WinDbg commands

Once you have the crash dump file, you can open it with WinDbg, and examine it using several useful commands

* `!analyze -v`

    Shows detailed information about the current exception.

* `!runaway`

    Shows thread times. This can be really useful to find badly behaved threads that are consuming a lot of CPU.

* `!threads`

    Shows a list of threads currently in execution.

* `!uniqstack`

    Displays all stacks of all the threads of the current process. You can view the stack trace of a single thread using the [`k` commands](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/k--kb--kc--kd--kp--kp--kv--display-stack-backtrace-).

* `~ns`

    Sets the thread with ID `n` as the current thread.

## Symbol files

You can run `.sympath C:\SymbolCache` to download and load [symbols](https://docs.microsoft.com/en-us/windows/win32/dxtecharts/debugging-with-symbols) from a specified path. To load symbols from Microsoft and Nuget.org, run `.sympath srv*C:\SymbolCache*https://msdl.microsoft.com/download/symbols;srv*C:\SymbolCache*https://symbols.nuget.org/download/symbols`.

Run `.reload /f` to force debugger to reload symbols for all modules from the specified path. Run `.symopt +0x40` followed by `.reload /f`, or `.reload /i`, if you want to load a symbol file even if it does not match the module. This can be useful if you want to use a symbol file built from the same source code.

Run `!chksym Module` to check symbol information for a particular module, and `!chksym Module Symbol` to check if a module matches a symbol file. Use an underscore character for each space character in the module name, or symbol path.

Run `!sym noisy` if you want to see detailed symbol loading information when these commands are run.

## Extensions

WinDbg is most useful for debugging managed application using the following extensions

* [SOS](https://docs.microsoft.com/en-us/dotnet/framework/tools/sos-dll-sos-debugging-extension)

    This extension is distributed along with the .NET framework can be loaded using `.loadby sos mscorwks`, or `.loadby sos clr` for .NET 4.

* [SOSEX](http://www.stevestechspot.com/default.aspx)

    This has several useful additions to the core SOS extension. It can be loaded using a command such as `.load c:\sosex\sosex.dll`.

* [Psscor2](https://blogs.msdn.microsoft.com/amb/2011/04/28/free-download-psscor2-new-windbg-extension-for-debugging-net-4-0-applications/)

    Has several useful commands, especially commands for debugging ASP.NET applications. It can be loaded using a command such as `.load c:\psscor2\x86\psscor2.dll`.

## SOS extension

The SOS extension has several useful commands, particularly

* `!clrstack -p`

    Prints the stack trace of the current thread. This only works for managed threads. If you have loaded symbols for your assemblies, you can see very useful information in the stack trace.

* `!dumpheap`

    Dumps the objects from the heap. You can dump objects of a specific type by using the `-type` option e.g. `!dumpheap -type System.Threading.Thread`. This can be really useful to list all objects and their addresses. By knowing the number of objects of a particular type in use, you can debug resource exhaustion problems.

* `!do address`

    Dumps information about the object at the address specified. Value of primitive fields of the object are displayed and other references can be further examined using this command.

* `!da`

    Prints information about an array

## SOSEX extension

The SOSEX extension has the following commands that are particularly useful

* `!refs`

    Prints all objects that reference the object specified.

* `!dlk`

    Searches for possible deadlocks.

## Psscor2 extension

The Psscor2 extension has one particularly useful command, among several others, that can come in handy when troubleshooting network related issues

* `!PrintIPAddress`

    Prints the IP address of the specified [IPAddress](https://docs.microsoft.com/en-us/dotnet/api/system.net.ipaddress) instance.

This short post is meant to whet your appetite for post-mortem debugging and to point you in the right direction.

Enjoy!
