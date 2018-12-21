---
layout: default
title: Stream WebM using GStreamer over TCP
tags: webm gstreamer
comments: true
---
# Stream WebM using GStreamer over TCP

This is a quick post to record how audio/video encapsulated in WebM can be streamed over TCP, using GStreamer.

## Receiving End

Change the sink devices as appropriate, and execute the following command

```bash
gst-launch-1.0 tcpserversrc port=9001 ! matroskademux name=d d. ! queue
! vp8dec ! autovideosink d. ! queue ! vorbisdec ! audioconvert ! audioresample ! autoaudiosink sync=false
```

## Sending End

Change the source devices as appropriate, and execute the following command

```bash
gst-launch-1.0 autovideosrc ! videoconvert ! vp8enc ! queue ! mux. autoaudiosrc ! audioconvert ! audioresample ! vorbisenc ! queue ! mux. webmmux name=mux streamable=true ! tcpclientsink port=9001
```

If you want to read a file and send that across, the following command can achieve that

```bash
gst-launch-1.0 filesrc location=big_buck_bunny_480p_stereo.ogg ! oggdemux name=demux demux. ! queue ! theoradec ! videoconvert ! vp8enc speed=2 ! queue ! mux. demux. ! queue ! vorbisdec ! audiorate tolerance=20000000 ! vorbisenc ! queue ! mux. webmmux streamable=true name=mux ! tcpclientsink port=9001
```

## Send to multiple receivers using Tee

The tee element can be used in the pipeline to stream WebM to multiple receivers

```bash
gst-launch-1.0 autovideosrc ! videoconvert ! vp8enc ! tee name=vt ! queue ! mux1. autoaudiosrc ! audioconvert ! audioresample ! vorbisenc ! tee name=at ! queue ! mux1. webmmux name=mux1 streamable=true ! tcpclientsink port=9001 vt. ! queue ! mux2. at. ! queue ! mux2. webmmux name=mux2 streamable=true ! tcpclientsink port=9002
```
