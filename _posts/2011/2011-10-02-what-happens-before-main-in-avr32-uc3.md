---
layout: default
title: What happens before main in AVR32 UC3
tags: main function avr
comments: true
---

Example projects in AVR32 Studio use a two-step startup procedure that occurs in the following order

1. `trampoline.x`

    It is used to bypass the bootloader. If you see the following linker instructions in the command line you're using this code file `-Wl,-e,_trampoline`. Once done, it jumps to code section `_stext`.

2. `crt0.x`

    `_stext` code section entry point is situated in this file. Once done, it jumps to `main`.
