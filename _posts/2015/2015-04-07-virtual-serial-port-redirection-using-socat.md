---
layout: default
title: Virtual serial port redirection using socat
tags: virtual serial socat netcat
comments: true
---
# Virtual serial port redirection using socat

Here's how socat can be used to redirect one serial port to another on Ubuntu

```bash
sudo socat -d -d pty,link=/dev/ttyS0,raw,echo=0 pty,link=/dev/ttyS1,raw,echo=0
```

Assuming both serial devices above are not assigned to a real device. If the above command is successful, you can send data from on serial port to another using a terminal emulator such as screen

```bash
screen /dev/ttyS0 115200
```

Install screen using `sudo apt-get screen` if not already installed. Repeat the above command on another prompt for the other serial device, and you're good to go. Quit screen using Ctrl-A .

socat can also be used to perform serial to TCP redirection

```bash
sudo socat -d -d pty,link=/dev/ttyS0,raw,echo=0 tcp-listen:8000
```

Now, you should be able to use screen to send and receive data on the serial port, while you use something like netcat to receive and send data to the serial port

```bash
netcat 127.0.0.1 8000
```
