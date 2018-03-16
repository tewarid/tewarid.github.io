---
layout: default
title: Random numbers and Math on AVR32
tags: math random c avr
comments: true
---

Probably not a very useful post for veterans but might be useful for those like me who are new to AVR32\. In this post, I show how to use the USART example application supplied with AVR32 Studio 2.6, to calculate and print a natural log of random numbers to the serial port.

### The Project

We'll start by creating a new AVR Example Project. Since I have an EVK1001 board I chose the EVK1101 - DRIVERS - USART example for AT32UC3B0256.

The reason for choosing this particular sample app is because I can then nicely show something over the serial port. The default baud rate of the serial port is 57600\. You can use one of several  USB to serial adapters if your PC does not have a serial port (very common these days). To establish a terminal with the serial port you can use the excellent TeraTerm (ttsh2) utility.

### Code

I added the code that prints the log values after the following line in `usart_example.c`

```c
  usart_write_line(EXAMPLE_USART, "Hello, this is AT32UC3 saying hello! (press enter)\n");
```

Here's how the code looks

```c
  char str[100];
  double r;
  r = (double)rand() / RAND_MAX;
  sprintf(str, "log(%lf) = %lf\n", r, log(r));
  usart_write_line(EXAMPLE_USART, str);
  r = (double)rand() / RAND_MAX;
  sprintf(str, "log(%lf) = %lf\n", r, log(r));
  usart_write_line(EXAMPLE_USART, str);
  r = (double)rand() / RAND_MAX;
  sprintf(str, "log(%lf) = %lf\n", r, log(r));
  usart_write_line(EXAMPLE_USART, str);
```

You'll also need to add the following headers to the source file

```c
#include "stdio.h"
#include "limits.h"
#include "math.h"
```

### Build

If you perform a build at this point you'll probably get an error from the linker (ld) such as

```text
src\usart_example.o: In function `main':
C:\as4e-ide\workspace\usart\Debug/..\src/usart_example.c:299: undefined reference to `log'
collect2: ld returned 1 exit status
```

The reason being that the linker has no way of knowing that you'll be using the math library unless you specify so. To do that now, head over to the 32-bit AVR/GNU C Linker settings in the project properties. Add a new library to Libraries (`-l`) called m.

![Libraries](/assets/img/avr32-studio-libraries-m.jpg)

Now, you should be able to build successfully.

### Deploy and test

You can now deploy the elf file to your development board. I used a JTAGICE mkII target from within AVR32 Studio. Here's how the output should look if all goes well

```text
Hello, this is AT32UC3 saying hello! (press enter)
log(0.970751) = -0.029686
log(0.261253) = -1.342268
log(0.857064) = -0.154242

Goodbye.
```
