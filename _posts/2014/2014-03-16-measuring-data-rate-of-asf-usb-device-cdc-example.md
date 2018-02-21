---
layout: default
title: Measuring data rate of ASF USB Device CDC example
tags: data rate asf usb cdc
---

Atmel Studio 6.1 provides an example project for Atmel Software Framework (ASF) 3.12.1, called _USB Device CDC Example - EVK1101_. EVK1101 is an evaluation kit for the AT32UC3B0256 part, that has 256 KB of flash memory. The example though is equally valid for other variants of that part, with more or less flash memory.

I [modified](https://github.com/tewarid/avr32-usb-device-cdc-example) the sample code so that

* It can be programmed to part AT32UC3B0512 (used by my target board)
* Code in callback `uart_rx_notify` of `uart_uc3.c` is commented out so it does nothing
* The `while` loop in `main.c` echoes back characters received over USB, as shown below

```c
int value;

while (true) {
    if (udi_cdc_is_rx_ready()) {
        value = udi_cdc_getc();
        if (!udi_cdc_is_tx_ready()) {
            // Fifo full
            udi_cdc_signal_overrun();
        }
        else
        {
            udi_cdc_putc(value);
        }
    }
}
```

I then compiled the code and programmed it to my target using a JTAGICE mkII. Connecting the target to a Windows PC results in creation of a serial port on the PC. A driver is provided with the example. If you use Windows 8, you'll require a [(self-)signed driver](https://github.com/tewarid/atmel-usb-cdc-virtual-com-driver), that is, if you haven't disabled that check.

Measuring data rate is then a matter of sending a known amount of data and dividing it by the time required to send it. Since I'm echoing back data, I divided that result by 2\. Just to be sure that my code modifications were reliable, I compared the echoed back data with the original. To communicate over the serial port, I used a handy tool called [SerialTool](https://github.com/tewarid/net-tools/tree/master/SerialTool) I created a while back (requires .NET framework 4.5 or mono 3.2.x).

The average data rate that I was able to measure is in the range of 3200 bytes per seconds or just shy of 26000 bits per second. Pretty lame, I think.

## Improving data rate

The trick to improving the data rate is to use alternate functions that receive/transmit multiple bytes per read/write. Atmel's [AVR4907: ASF - USB Device CDC Application](http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591824) note hints to the existence of these functions in `udi_cdc.h`.

The modified `while` loop in `main.c` produces a much more respectable 458000 bytes per second or 3664000 bits per second. That too while debugging using JTAG.

```c
int len;
const int BUF_SIZE = 10;
char buf[BUF_SIZE];

while (true) {
    if (udi_cdc_is_rx_ready()) {

        // blocks until BUF_SIZE bytes are received
        len = udi_cdc_read_buf(buf, BUF_SIZE);

        if (len == BUF_SIZE) continue;

        while (!udi_cdc_is_tx_ready()) {
            // Fifo full
        }

        udi_cdc_write_buf(buf, BUF_SIZE);
    }
}
```

The echo logic above has a slight design flaw. If data is not a multiple of 10 bytes, the code will be stuck in the call to `udi_cdc_read_buf` towards the end of the data. I chose 10 quite arbitrarily.
