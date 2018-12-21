---
layout: default
title: FreeRTOS task control block and stack in AVR32
tags: freertos tcb avr
comments: true
---
# FreeRTOS task control block and stack in AVR32

FreeRTOS allocates memory for the task's control block (TCB) structure (`tskTCB` type in `tasks.c`), followed by memory for its stack, when your code calls `xTaskCreate` to create a new task. To find the TCB of the currently executing task look at `pxCurrentTCB` in `tasks.c`. A color coded view of how the `tskTCB` structure looks in memory follows. What you see will vary based on which fields are enabled in your port.

* <span style="color:#c0c0c0;">Top of previous task's stack is here</span> - see `pxPortInitialiseStack` in `port.c`
* Fields of IDLE task's TCB
    * <span style="color:#ff0000;">Pointer to top of stack (higher memory)</span>
    * <span style="color:#cc99ff;">xGenericListItem structure</span>
    * <span style="color:#00ccff;">xEventListItem structure</span>
    * <span style="color:#99cc00;">Task priority</span>
    * <span style="color:#ff9900;">Pointer to start of stack (lower memory)</span>
    * <span style="color:#ff00ff;">Process Name (16 bytes)</span>
* Start of IDLE task's stack is here - stack grows from top to start i.e. higher memory to lower

<span style="font-family:monospace;font-size:small;"><br>
0x00005CE0 <span style="color:#c0c0c0;">a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5</span> ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005CF0 <span style="color:#c0c0c0;">a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5</span> ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005D00 <span style="color:#c0c0c0;">a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5</span> ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005D10 <span style="color:#c0c0c0;">a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5</span> ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005D20 <span style="color:#c0c0c0;">a5 a5 a5 a5 a5 a5 a5 a5 00 00 00 00 07 07 07 07</span> ¥¥¥¥¥¥¥¥\.\.\.\.\.\.\.\. <br>
0x00005D30 <span style="color:#c0c0c0;">06 06 06 06 05 05 05 05 04 04 04 04 03 03 03 03</span> \.\.\.\.\.\.\.\.\.\.\.\.\.\.\.. <br>
0x00005D40 <span style="color:#c0c0c0;">02 02 02 02 01 01 01 01 ff 00 00 ff 00 40 00 00</span> \.\.\.\.\.\.\.\.ÿ..ÿ.@.. <br>
0x00005D50 <span style="color:#c0c0c0;">80 00 5c 7c de ad be ef 00 00 00 00 0b 0b 0b 0b</span> €.\|Þ..ï\.\.\.\.\.\.\.\. <br>
0x00005D60 <span style="color:#c0c0c0;">0a 0a 0a 0a 09 09 09 09 08 08 08 08</span> a5 a5 a5 a5 \.\.\.\.\.\.\.\.\.\.\.\.¥¥¥¥ <br>
0x00005D70 6c 80 5b a3 00 00 00 49 <span style="color:#ff0000;">00 00 61 78</span> <span style="color:#cc99ff;">85 ec bc 8d</span> l€[£\.\.\.I..ax.ì.. <br>
0x00005D80 <span style="color:#cc99ff;">00 00 18 04 00 00 18 04 00 00 5d 78 00 00 17 fc</span> \.\.\.\.\.\.\.\.\..]x\.\.\.ü <br>
0x00005D90 <span style="color:#00ccff;">00 00 00 08 d5 b6 4a 10 b0 b0 4d 2b 00 00 5d 78</span> \.\.\..Õ¶J.°°M+..]x <br>
0x00005DA0 <span style="color:#00ccff;">00 00 00 00</span> <span style="color:#99cc00;">00 00 00 00</span> <span style="color:#ff9900;">00 00 5d c0</span> <span style="color:#ff00ff;">49 44 4c 45</span> \.\.\.\.\.\.\.\.\..]ÀIDLE <br>
0x00005DB0 <span style="color:#ff00ff;">00 00 00 00 00 00 00 00 00 00 00 00</span> 00 00 04 09 \.\.\.\.\.\.\.\.\.\.\.\.\.\.\.. <br>
0x00005DC0 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005DD0 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005DE0 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005DF0 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E00 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E10 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E20 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E30 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E40 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E50 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E60 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E70 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E80 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005E90 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005EA0 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ <br>
0x00005EB0 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 a5 ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥</span>
