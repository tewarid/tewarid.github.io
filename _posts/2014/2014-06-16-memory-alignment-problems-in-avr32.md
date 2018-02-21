---
layout: default
title: Memory alignment problems in AVR32
tags: c memory alignment programming atmel studio gnu
---

This post summarizes some memory alignment problems I've had with AVR32 and Atmel's GNU toolchain that ships with Atmel Studio 6.2.

* INTRAM section length in the linker script

    My problem began when I changed the INTRAM section length in the linker script. The code fails, and I am not even able to start a debug session using JTAGICE mkII. Lengths of `0x00007FFC` and `0x00008000` work all right, `0x00007FFF` does not. The former are a multiple of 4 i.e. 32-bit aligned, the latter is not.

* Casting to a pointer of different type

    Casting an `unsigned char` pointer, to pointer to a multi-byte scalar type such as `unsigned int`, and accessing it, for example `*((unsigned int*)(&array[index]))`, may lead to Data Read Address exception. If you are stuck in that exception handler, you've got a memory read alignment problem.

* Passing pointers to unaligned members of packed `struct`s

    I haven't (yet) had any problems with [packed](http://delog.wordpress.com/2011/05/25/points-to-remember-regarding-c-pointers/) `struct`s, but beware of passing pointers to members of such `struct`s to other functions. If your architecture does not support unaligned access (AVR32 being one such architecture), the processor may fault when functions try to read or write memory through misaligned pointers. Passing a pointer to the `struct` itself is fine because the compiler knows it is packed, and will access its members in a safe way.
