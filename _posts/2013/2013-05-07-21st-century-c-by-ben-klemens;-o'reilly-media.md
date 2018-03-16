---
layout: default
title: 21st Century C by Ben Klemens; O'Reilly Media
tags: book review
comments: true
---

![21st Century C](http://akamaicovers.oreilly.com/images/0636920025108/lrg.jpg)

21st Century C is a useful read for the budding Linux hacker, due to its focus on the GNU toolchain. Among its highlights is the constant reminder of improvements to the C language since the original ANSI C standard (C89). It covers a wide range of topics - you may want to skim particular topics and return to them when you see the need.

The book is divided into two parts. Part 1 starts with mundane things like installing a C compiler and compiling your C program. It then moves on to useful topics such as debugging using GDB, checking for errors using Valgrind, unit testing, building documentation using Doxygen and CWEB, and packaging your project using Autotools. If you have executed "./configure" and then "make install", but never looked under the hood, now is the time to do that. The chapter on version control using Git is probably the best coverage of Git I have seen in any book.

Part 2 focuses on the C language itself. This part starts with coverage of pointers, followed by a chapter on C syntax that programmers should avoid. The following chapters discuss usage of macros to write succinct code, text handling, and better structs and typedefs. The chapter on object oriented programming delves into using anonymous structs for extending objects, function pointers, and building and freeing objects. The last chapter wraps up by introducing several popular open source libraries such as GLib, POSIX, GSL, SQLite, libxml, and cURL.

You can cobble together the knowledge dispensed in this book by reading manuals and articles over the internet, but it is convenient to have it all together in one place to be read at your leisure.
