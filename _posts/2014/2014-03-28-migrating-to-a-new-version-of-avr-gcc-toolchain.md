---
layout: default
title: Migrating to a new version of AVR-GCC toolchain
tags: asf atmel studio programming c avr
comments: true
---
# Migrating to a new version of AVR-GCC toolchain

I have posted in the past about [migrating]({% link _posts/2012/2012-08-29-migrating-an-avr32-studio-project-to-atmel-studio-6.md %}) from AVR32 Studio to Atmel Studio 6. In that post, I mention that I am having issues with newer version of the toolchain. In this post, I explain why.

The first thing I did is [upgrade]({% link _posts/2014/2014-03-27-upgrading-to-a-newer-version-of-atmel-software-framework.md %}) the Atmel Software Framework (ASF). The version used earlier is 1.7.0, quite dated compared to version 3.15.0 that ships with Atmel Studio 6.2\. Updating ASF version alone does not make our issue go away.

Our application uses a Synchronous Serial Controller (SSC) to transmit data. Data is continuously copied from SRAM using a Peripheral DMA Controller (PDCA). PDCA generates an interrupt when it has transmitted the specified data (triggered when TCRR returns to zero). The routine that handles that interrupt, sets the memory address (MARR) and size of data (TCRR) that will be transmitted next.

I got the first hints of where the problem could be when

* Debugging with JTAGICE mkII, I'd discover the processor hung at some exception handler (different each time application source is changed and recompiled) such as _handle_Instruction_Address, _handle_Data_Address_Read, _handle_Data_Address_Write etc. Upon looking for an answer, I realized that this is quite common when a stack overflow or buffer overflow has occurred.

* Analyzing the data transmitted by the SSC using a [Saleae Logic 16](https://www.saleae.com/logic16), I noted that only the first two DMA transfers were actually occurring. These were programmed at initialization, hinting at the fact that the interrupt handler is the source of the problem.

I got a hint for the solution from the [AVR32006 : Getting started with GCC for AVR32](http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591128) application note. Adding `__attribute__((interrupt("full")))` to the function definition solves the problem. That tells the compiler to return from the function using the special `rete` instruction. You can also use the `ISR` macro to define the interrupt handler function.

An example follows

```c
__attribute__((interrupt("full"))) void pdca_interrupt_handler(void)
{
// rearm the PDCA
}
```

This is how the interrupt handler is registered

```c
INTC_register_interrupt( (__int_handler) &pdca_interrupt_handler, AVR32_PDCA_IRQ_1, AVR32_INTC_INT0);
```

Our application uses FreeRTOS, and that appropriately initializes the Interrupt Controller (INTC) and the EVBA system register.
