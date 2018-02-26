---
layout: default
title: Video streaming using jpeg encoding
tags: jpeg encoding live video gstreamer
---

Here's an example of a GStreamer pipeline that produces a less CPU intensive and low latency video stream using jpeg encoding. Audio in vorbis is muxed, along with the video, into a matroska stream. I tested this on Ubuntu 11.04.

```bash
gst-launch v4l2src decimate=3 ! video/x-raw-yuv,width=320,height=240 ! jpegenc ! queue2 ! m. alsasrc device=hw:2,0 ! audioconvert ! vorbisenc ! queue2 ! m. matroskamux name=m streamable=true ! tcpclientsink host=localhost port=9002
```

A [server]({% link _posts/2011/2011-04-26-stream-live-webm-video-to-browser-using-node.js-and-gstreamer.md %}) can stream it with a content type of `video/x-matroska`. Most browsers will not play it directly, but external plugins can be used.
