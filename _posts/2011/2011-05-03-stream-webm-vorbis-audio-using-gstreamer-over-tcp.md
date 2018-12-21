---
layout: default
title: Stream WebM vorbis audio using GStreamer over TCP
tags: vorbis stream webm tcp gstreamer
comments: true
---
# Stream WebM vorbis audio using GStreamer over TCP

 In this post, we'll use GStreamer commands to stream Vorbis audio within the WebM container, over TCP. A [Vorbis](https://xiph.org/vorbis/) audio stream has no metadata regarding the audio itself or any other timing information. It needs to be streamed within a container such as WebM or OGG, or using a protocol such as [RTP](http://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/tests/examples/rtp).

## Receiving End

Execute the following pipeline

```bash
gst-launch-1.0 tcpserversrc port=9001 ! matroskademux ! vorbisdec ! audioconvert ! autoaudiosink
```

## Sending End

Execute the following pipeline

```bash
gst-launch-1.0 filesrc location=big_buck_bunny_480p_stereo.ogg ! oggdemux ! vorbisparse ! webmmux streamable=true ! tcpclientsink port=9001
```

At the sending end, I extract a vorbis audio stream from an [ogg file](https://peach.blender.org/download/) and feed it to the receiving end.
