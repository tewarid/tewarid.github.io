---
layout: default
title: Python Cookbook by David Beazley, Brian K. Jones; O'Reilly Media
tags: book review python
comments: true
---

![Python Cookbook](http://akamaicovers.oreilly.com/images/0636920027072/lrg.jpg)

Python Cookbook is an extensive tome of recipes for the Python 3 programmer. It is a perfect companion book for those migrating Python 2 code to Python 3. If you are stuck with Python 2, you may still find the second edition of the book for sale, but the recipes may be dated as they cover Python 2.4. It is not a beginners book. If you are looking for a beginners book, I recommend Learning Python by Mark Lutz.

A quick chapter summary follows.

Chapter 1 has recipes involving manipulation of built-in structures such as dictionaries and sequences. Usage of heapq module for implementing priority queues is demonstrated.

Chapter 2 covers string and text manipulation, with extensive use of regular expressions.

Chapter 3 has recipes for working with numbers, dates, and times. Usage of numpy module for matrix and linear algebra calculations is demonstrated.

Chapter 4 provides recipes for implementing iterators and generators.

Chapter 5 covers File and I/O, including recipes for reading and writing compressed files, memory mapping binary files, and communicating with serial ports.

Chapter 6 moves on to more advanced recipes for encoding and processing, such as reading and writing CSV, JSON, XML, Hex digits, and Base64.

Chapter 7 provides recipes for functions and closures.

Chapter 8 provides recipes for classes and objects, such as creating managed attributes, lazily computed properties, and extending classes with mixins. It also covers common patterns such as state, and visitor.

Chapter 9 digs deeper into metaprogramming.

Chapter 10 has recipes for modules and packages, such as for splitting a module into multiple files using packages, and loading modules from another machine using import hooks.

Chapter 11 provides recipes for network and web programming. I didn't know you could use ip_network objects to generate IP addresses and check for membership. It also covers event-driven I/O but does not introduce any new framework.

Chapter 12 has recipes for concurrency. It discusses implementing concurrency using generators (coroutines), but doesn't cover frameworks such as gevent, it does mention PEP 3156 that covers those.

Chapter 13 has recipes for writing utility scripts for system administration.

Chapter 14 has recipes for unit testing, debugging, exception handling, and profiling.

Chapter 15 wraps it up with recipes for extending Python using C.

I've added this book to my list of references to look into, before heading to Google. Source code listings use syntax highlighting, a nice touch that makes the code easier, and less boring, to read.

I thank O'Reilly media for providing the book to review.
