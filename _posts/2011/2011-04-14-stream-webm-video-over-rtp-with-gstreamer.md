---
layout: default
title: Stream WebM video over RTP with GStreamer
tags: webm gstreamer
comments: true
---
# Stream WebM video over RTP with GStreamer

In this post, we'll see how [WebM video](https://tools.ietf.org/html/rfc7741) can be streamed over [RTP](https://tools.ietf.org/html/rfc3550) using the command line.

## Stream WebM video over RTP/UDP

Issue the following command to start streaming. We're using the test video source, but you can use any other source.

```bash
gst-launch-1.0 -v videotestsrc ! vp8enc ! rtpvp8pay ! udpsink host=127.0.0.1 port=9001
```

Take note of the following information output to the console. We'll need that to play the stream.

```text
/GstPipeline:pipeline0/GstUDPSink:udpsink0.GstPad:sink: caps = application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)VP8, payload=(int)96, ssrc=(uint)1592441352, timestamp-offset=(uint)2504244264, seqnum-offset=(uint)22149, a-framerate=(string)30
```

In a peer-to-peer application you will probably transmit the parameters after caps above using RTCP, or some other signaling mechanism such as SIP or XMPP.

## Receive and play the stream

Issue the following command to play the video stream

```bash
gst-launch-1.0 udpsrc port=9001 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)VP8, payload=(int)96, ssrc=(uint)1592441352, timestamp-offset=(uint)2504244264, seqnum-offset=(uint)22149, a-framerate=(string)30" ! rtpvp8depay ! vp8dec ! videoconvert ! autovideosink
```

It really is that simple with GStreamer!
