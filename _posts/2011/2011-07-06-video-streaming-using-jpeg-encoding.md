---
layout: default
title: Video streaming using jpeg encoding
tags: jpeg encoding live video gstreamer
comments: true
---

Here's an example of a GStreamer pipeline that produces a less CPU intensive and low latency video stream using jpeg encoding. Audio in vorbis is muxed, along with the video, into a matroska stream.

```bash
gst-launch-1.0 autovideosrc ! jpegenc ! queue2 ! m. autoaudiosrc ! audioconvert ! vorbisenc ! queue2 ! m. matroskamux name=m streamable=true ! tcpclientsink host=localhost port=9002
```

A server can stream it with a content type of `video/x-matroska`. Most browsers will not play it directly, but external plugins can be used.
