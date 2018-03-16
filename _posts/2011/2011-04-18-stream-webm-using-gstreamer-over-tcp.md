---
layout: default
title: Stream WebM using GStreamer over TCP
tags: webm gstreamer
comments: true
---

This is a quick post to record how audio/video encapsulated in WebM can be streamed over TCP, using GStreamer.

### Receiving End

Change the sink devices as appropriate, and execute the following command

```bash
gst-launch tcpserversrc port=9001 ! matroskademux name=d d. ! queue2 ! vp8dec ! ffmpegcolorspace ! autovideosink d. ! queue2 ! vorbisdec ! audioconvert ! audioresample ! alsasink sync=false
```

### Sending End

Change the source devices as appropriate, and execute the following command

```bash
gst-launch videotestsrc ! video/x-raw-rgb,framerate=5/1 ! ffmpegcolorspace ! vp8enc ! queue2 ! mux. audiotestsrc ! audioconvert ! audioresample ! vorbisenc ! queue2 ! mux. webmmux name=mux streamable=true ! tcpclientsink port=9001
```

If you want to read a file and send that across, the following command can achieve that

```bash
gst-launch filesrc location=big_buck_bunny_480p_stereo.ogg ! oggdemux name=demux demux. ! queue2 ! theoradec ! ffmpegcolorspace ! vp8enc speed=2 ! queue2 ! mux. demux. ! queue2 ! vorbisdec ! audiorate tolerance=20000000 ! vorbisenc ! queue2 ! mux. webmmux streamable=true name=mux ! tcpclientsink port=9001
```

If you transmit video with its nominal frame rate, by removing the framerate property to ffmpegcolorspace, you may see the following message

```text
WARNING: from element /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstXImageSink:autovideosink0-actual-sink-ximage: A lot of buffers are being dropped.
Additional debug info:
gstbasesink.c(2866): gst_base_sink_is_too_late (): /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstXImageSink:autovideosink0-actual-sink-ximage:
There may be a timestamping problem, or this computer is too slow.
```

This does not happen if you use a filesink as a destination at the receiving end, which means `autovideosink` has some issue with my Virtual Box Ubuntu setup. Adding a speed parameter (with a value of 2) to the vp8enc element solves this issue.

### Send to multiple receivers using Tee

The tee element can be used in the pipeline to stream WebM to multiple receivers

```bash
gst-launch videotestsrc ! video/x-raw-rgb,framerate=5/1 ! ffmpegcolorspace ! vp8enc ! tee name=vt ! queue2 ! mux1\. audiotestsrc ! audioconvert ! audioresample ! vorbisenc ! tee name=at ! queue2 ! mux1\. webmmux name=mux1 streamable=true ! tcpclientsink port=9001 vt. ! queue2 ! mux2\. at. ! queue2 ! mux2\. webmmux name=mux2 streamable=true ! tcpclientsink port=9002
```
