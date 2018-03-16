---
layout: default
title: Scripting for the .NET CLR
tags: .net clr c# scripting
comments: true
---

This post documents the pros and cons of some of the popular scripting options for the .NET Common Language Runtime (CLR).

* [CS-Script](http://www.csscript.net/)

    * Scripts are ECMA-compliant C#
    * Script is precompiled before execution, execution is as fast as compiled C#
    * Runs on .NET CLR and Mono
    * Provides capability to compile a script to DLL or executable
    * Can be embedded in a .NET application to provided scripting capability

* [CsharpRepl](http://www.mono-project.com/CsharpRepl)

    * Built on top of the Mono.CSharp library
    * C# syntax
    * Scripts are interpreted, not as fast as compiled code
    * Readily available on most Linux distributions (mono-complete package on Debian based distributions)

* [IronPython](http://ironpython.net/)

    * Scripts are written in Python (2.7)
    * Useful if you already know Python
    * Can be embedded in a .NET application to provided scripting capability
    * As per established benchmarks, it performs better than CPython [[aosabook.org](http://aosabook.org/en/ironlang.html)]

* Other language options

    * [IronRuby](http://ironruby.codeplex.com/)
    * [IronScheme](https://ironscheme.codeplex.com/)
    * [IronJS](https://github.com/fholm/IronJS/)
