---
layout: default
title: Merge pdf files using ghostscript
tags: ghostscript pdf merge windows gsview
---

To merge or join pdf files with [ghostscript](http://www.ghostscript.com/), from the command line

```cmd
"c:\Program Files\gs\gs9.06\bin\gswin64.exe" -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=join.pdf -dBATCH ch01.pdf ch02.pdf ch03.pdf ch04.pdf ch05.pdf ch06.pdf ch07.pdf ch08.pdf ch09.pdf ch10.pdf ch11.pdf ch12.pdf ch13.pdf AppA.pdf AppB.pdf
```

Change the command appropriately for your operating system and files.

A pity [gsview](http://pages.cs.wisc.edu/~ghost/gsview/) does not provide a GUI for doing that.
