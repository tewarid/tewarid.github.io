---
layout: default
title: Path to toolchain binaries in AVR32 Studio
tags: avr studio path gcc toolchain
comments: true
---
# Path to toolchain binaries in AVR32 Studio

If you haven't already, create a AVR C project. Open the properties of the project. Under C/C++ Build, select Environment, look for the PATH variable. It should have an entry that reads like `<ide root folder>\plugins\com.atmel.avr.toolchains.win32.x86_3.0.0.201009140852\os\win32\x86\bin`. That is the folder containing all the toolchain binaries including avr32-objcopy.exe.
