---
layout: default
title: Live WebM video streaming with Flumotion
tags: webm gstreamer flumotion
comments: true
---

The objective of this post is to setup live WebM streaming using Flumotion on a Linux box running Ubuntu 10.04.

[WebM](http://www.webmproject.org) is a codec and container format based on the matroska container, and uses the Vorbis codec for audio and the VP8 codec for video. It is a royalty-free format for the Web. H.264 is an open standard but is encumbered with patents. Although Ogg is quite similar to WebM, Ogg suffers from FUD regarding its royalty-free standing.

### Install Flumotion

Add the repository source `https://launchpad.net/~flumotion-dev/+archive/flumotion` in Synaptic Package Manager, and install Flumotion version `0.8.1-1flu1~lucid1`.

### Build and install VP8 plugin and GStreamer

Install the following packages and their dependencies using Synaptics Package Manager

* bison
* flex
* libasound2-dev
* libglib2.0-dev
* libx11-dev
* libxml2-dev
* libvorbis-dev
* x11proto-video-dev
* yasm (required to build VP8 lib from Google)

Download [source code](http://code.google.com/p/webm) of VP8 codec library version 0.9.6 and execute the following commands to build and install it

```bash
./configure
make
sudo make install
```

Install the following in the same manner

* ORC [version 0.4.13](https://gstreamer.freedesktop.org/projects/orc.html)
* GStreamer [version 0.10.32](http://gstreamer.freedesktop.org/src/gstreamer/)
* GStreamer [plugins base version 0.10.32](http://gstreamer.freedesktop.org/src/gst-plugins-base/)
* GStreamer [plugins good version 0.10.28](http://gstreamer.freedesktop.org/src/gst-plugins-good/)
* GStreamer [plugins bad version 0.10.21](http://gstreamer.freedesktop.org/src/gst-plugins-bad/)

### Prepare GStreamer

`make install` puts libraries under `/usr/local/lib`. We'll have to add that path to the `LD_LIBRARY_PATH` environment variable. You can configure make to install libraries and binaries to `/usr` instead of `/usr/local` by passing `--prefix=/usr` option to the configure commands issued above.

We'll need to rebuild the GStreamer plugins registry.

Open a terminal and execute

```bash
export LD_LIBRARY_PATH=/usr/local/lib
export GST_PLUGIN_SYSTEM_PATH=/usr/local/lib/gstreamer-0.10
rm ~/.gstreamer/registry*
gst-inspect
```

Test that GStreamer is properly setup and can encode/decode WebM, using the following commands

```bash
gst-launch audiotestsrc ! audioconvert ! audio/x-raw-int,channels=2 ! alsasink

gst-launch videotestsrc ! autovideosink

gst-launch filesrc location=file.webm ! matroskademux name=d d. ! queue ! vp8dec ! ffmpegcolorspace ! autovideosink d. ! queue ! vorbisdec ! audioconvert ! audioresample ! alsasink

gst-launch ximagesrc ! video/x-raw-rgb,framerate=5/1 ! ffmpegcolorspace ! vp8enc ! queue ! mux. audiotestsrc ! audioconvert ! audioresample ! vorbisenc ! queue ! mux. webmmux name="mux" ! filesink location=desktop.webm
```

We are now ready to execute flumotion-admin to create a test WebM audio/video stream over HTTP. Use the same terminal session so that environment variables exported earlier are available to flumotion-admin, otherwise you'll get the following message when you setup live streaming

```text
Worker 'localhost' is missing GStreamer element 'vp8enc'. Please install the necessary GStreamer plug-ins that provide these elements and restart the worker.
```

### Debug failure to load a GStreamer plugin

If a plugin doesn't load, you may [troubleshoot](http://gstreamer.freedesktop.org/data/doc/gstreamer/head/faq/html/chapter-troubleshooting.html) the issue by trying to load plugin using gst-inspect

```bash
export GST_DEBUG=5
gst-inspect /usr/local/lib/gstreamer-0.10/libgstvp8.so
```

Setting [debug trace level](https://gstreamer.freedesktop.org/documentation/plugin-development/appendix/checklist-element.html#debugging) shows detailed debug messages.

### Execute a test audio/video using Flumotion

Follow the Flumotion manual, see section _A Simple Example_.

### Play in Chrome using the video element

Create an HTML file with the following markup and open it in Chrome.

```html
<html>
<head>
</head>
<body>
  <video autoplay="true" controls="controls">
    <source src="http://192.168.2.2:8800/webm-audio-video/" type="video/webm">
  </video>
</body>
</html>
```

![Flumotion](/assets/img/flumotion.jpg)
