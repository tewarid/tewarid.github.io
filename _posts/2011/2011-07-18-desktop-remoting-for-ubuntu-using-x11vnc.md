---
layout: default
title: Desktop remoting for Ubuntu using x11vnc
tags: x11vnc ubuntu
---

[x11vnc](http://www.karlrunge.com/x11vnc/) is a neat way to remote an existing X11 session to another machine. You can use a regular VNC client on the remote machine to interact with your Ubuntu Desktop.

### Installation

Execute the following command to install x11vnc

```bash
sudo apt-get install x11vnc
```

Then, execute x11vnc thus

```bash
x11vnc
```

### VNC Client

There are several VNC clients you can choose from but I prefer the [TightVNC](http://www.tightvnc.com/) Viewer. Once installed, point the viewer to `host_name:display_number` or `host_ip:display_number` e.g. `192.168.0.2:0`. The display number can be obtained from a terminal window on Ubuntu thus

```bash
echo $DISPLAY
```

Some neat features to try out

* Send keyboard commands like Alt+Tab or Ctrl+Alt+Del
* Copy to or paste from the remote machine
