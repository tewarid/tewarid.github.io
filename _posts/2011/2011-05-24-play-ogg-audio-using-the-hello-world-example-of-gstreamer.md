---
layout: default
title: Play ogg audio using the Hello World example of GStreamer
tags: gstreamer c build hello world
comments: true
---
# Play ogg audio using the Hello World example of GStreamer

In this post, we see how to build the [hello world](https://gstreamer.freedesktop.org/documentation/application-development/basics/helloworld.html) example in C that can be found in the GStreamer application development manual.

## Dependencies

I installed the following packages on Ubuntu 11.04

* libgstreamer0.10-dev
* libglib2.0-dev
* libgtk2.0-dev

Get the equivalent packages for your distribution.

## Build

Assuming your source code is located in `hello_world.c`, you can compile the source code thus

```bash
gcc hello_world.c `pkg-config --cflags --libs glib-2.0 gstreamer-0.10` -o hello_world
```

## Execute

As follows

```bash
./hello_world file.ogg
```
