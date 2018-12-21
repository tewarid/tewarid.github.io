---
layout: default
title: Execute code from SRAM on AVR32
tags: sram avr linker script
comments: true
---
# Execute code from SRAM on AVR32

Atmel's [AVR32825: Executing code from external SDRAM](http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591936) application note explains how to execute code from [SRAM](http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591182) and [AVR32795: Using the GNU Linker Scripts on AVR UC3 Devices](http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591310) explains how to use linker scripts. GNU [ld](http://sourceware.org/binutils/docs/ld/index.html) and [as](http://sourceware.org/binutils/docs/as/index.html) docs are also useful references.

## Create a new section

Add the following section in the SECTIONS of linker script, probably after the `.data` section. The location pointer should be in the SRAM, usually indicated by a statement such as `. = ORIGIN(SRAM)`

```text
  .text_sram :
  {
    *(.text_sram.*)
  } >SRAM AT>FLASH
```

The `MEMORY` spec in the linker script should place `SRAM` and `FLASH` used above in the appropriate memory regions.

## Modify functions

Add the following attribute to the functions that will be located in the SRAM

```c
__attribute__((__section__(".text_sram")))
```

## Use objdump and nm to check the resulting elf

Execute `avr32-objdump` on the elf

```cmd
avr32-objdump -h file.elf
```

This should list something like

```text
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
...
  8 .data         000005d4  00000578  8000e778  0000ed78  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  9 .text_sram    00000044  00000b4c  8000ed4c  0000f34c  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 10 .bss          00004138  00000b90  8000ed90  0000f390  2**2
```

Use `avr32-nm` to check location of symbols in memory

```cmd
avr32-nm file.elf
```

This lists something like

```text
00000b4c T func
```

The function `func` is loaded into FLASH but executed from SRAM.

## A note on writing to flash memory

One reason you'll want to run code from SRAM is when you need to update flash memory. There are couple of situations when this can fail

* The security bit is set.
* The BOOTPROT fuse is programmed to protect the region of memory you're flashing.
