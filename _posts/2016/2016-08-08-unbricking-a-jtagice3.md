---
layout: default
title: Unbricking a JTAGICE3
tags: jtagice jtagice3 jtag ice unbrick
comments: true
---
# Unbricking a JTAGICE3

Atmel Studio 7 prompted me to upgrade a JTAGICE3 tool recently. I went ahead with the upgrade since I couldn't use the tool without it, and I have done it with the JTAGICE mkII on several occasions. After the upgrade was successfully completed, I found the JTAGICE3 in a state that is generally referred as bricked.

I left it aside for a couple of weeks until I decided to visit AVRFREAKS, and found a [solution](http://www.avrfreaks.net/forum/jtagice3-rescue-after-failed-programming?skey=jtagice3%20brick).

You'll need to put JTAGICE3 in bootloader mode. Short the pads highlighted in the image below, and plug it in.

![jtagice3-open.jpg](/assets/img/jtagice3-open.jpg)

Then, from Windows command line run

```cmd
C:\Program Files (x86)\Atmel\Studio\7.0\atbackend>atfw -t jtagice3 -a "C:\Program Files (x86)\Atmel\Studio\7.0\tools\JTAGICE3\jtagice3_fw.zip"
```
