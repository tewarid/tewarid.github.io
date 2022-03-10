---
layout: default
title: User space SPI communication in Linux
tags: raspberry pi spi linux kernel
comments: true
---
# User space SPI communication in Linux

Synchronous Peripheral Interface aka SPI is a rather fast and flexible bidirectional serial interface although it is unable to support as many devices per bus as the I2C bus. The Linux SPI interface supports accessing devices from user space applications using `ioctl` calls, which is less developer-friendly than the `linux/spi/spi.h` API available from kernel space.

In this post, we explore the different means of transferring data using the `linux/spi/spidev.h` header and `ioctl` call available in `sys/ioctl.h`.

## Open SPI device

The following code snippet shows how to open an SPI device

```c++
fd = open("/dev/spidev0.0", O_RDWR);
if (fd < 0)
{
    // error
}
```

Subsequently, the file descriptor can be used to configure the SPI interface, and to transfer data.

## Configure SPI interface

The following code snippet shows how to configure SPI interface characteristics such as transfer mode, bits per word, and clock speed

```c++
ioctl(fd, SPI_IOC_WR_MODE, SPI_MODE_2);
ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, 8);
ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, 8000000U);
```

Configuration can also be read via similar `ioctl` calls but using different requests such as `SPI_IOC_RD_MODE`, `SPI_IOC_RD_BITS_PER_WORD`, and `SPI_IOC_RD_MAX_SPEED_HZ`.

## Send only

The following code snippet demonstrates how to send data to a device without receiving any data from it

```c++
struct spi_ioc_transfer tr[1] = {
    {
        .tx_buf = (unsigned long)tx,
        .len = len,
        .delay_usecs = 10,
    },
};
errno = 0;
ioctl(fd, SPI_IOC_MESSAGE(1), &(tr));
if (errno != 0)
{
    // failed
}
```

Here, `tx` is a preconfigured buffer of length `len`, and we want to wait `10` microseconds after the last bit has been transferred.

## Send and then receive

The following code snippet demonstrates how to send data to a device such as a command, and then receive data from it

```c++
struct spi_ioc_transfer tr[2] = {
    {
        .tx_buf = (unsigned long)tx,
        .len = tx_len,
        .delay_usecs = 10,
    },
    {
        .rx_buf = (unsigned long)rx,
        .len = rx_len,
        .delay_usecs = 10,
    },
};
errno = 0;
ioctl(fd, SPI_IOC_MESSAGE(2), &(tr));
if (errno != 0)
{
    // failed
}
```

## Send and receive

The following code snippet demonstrates how to send data to a device and receive data at the same time i.e. transceive

```c++
struct spi_ioc_transfer tr[1] = {
    {
        .tx_buf = (unsigned long)tx,
        .rx_buf = (unsigned long)rx,
        .len = len,
        .delay_usecs = 10,
    }, 
};
errno = 0;
ioctl(fd, SPI_IOC_MESSAGE(1), &(tr));
if (errno != 0)
{
    // failed
}
```
