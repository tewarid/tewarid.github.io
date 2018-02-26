---
layout: default
title: Stream WebM video over RTP with GStreamer
tags: webm gstreamer
---

In post [Live WebM video streaming with Flumotion]({% link _posts/2011/2011-04-07-live-webm-video-streaming-with-flumotion.md %}) I discussed how to setup GStreamer with the appropriate WebM plugins, and use Flumotion to stream a live WebM feed over HTTP. In this post, we'll see how [WebM video](http://tools.ietf.org/html/draft-westin-payload-vp8-00) can be streamed over [RTP](http://www.ietf.org/rfc/rfc3550.txt) using the command line.

### GStreamer version

The version of source code we used in the previous post has a bug, the rtpvp8pay and rtpvp8depay plugins are not properly built. We'll have to build the following GStreamer components from their source code repository.

* GStreamer

    `git://anongit.freedesktop.org/gstreamer/gstreamer`

* Plugins base

    `git://anongit.freedesktop.org/gstreamer/gst-plugins-base`

* Plugins good

    `git://anongit.freedesktop.org/gstreamer/gst-plugins-good`

* Plugins bad

    `git://anongit.freedesktop.org/gstreamer/gst-plugins-bad`

`git clone` each component and use the commands at [Build and install VP8 plugin and GStreamer]({% link _posts/2011/2011-04-07-live-webm-video-streaming-with-flumotion.md %}#build-and-install-vp8-plugin-and-gstreamer) to build and install it.

### Stream WebM video over RTP/UDP

Issue the following command to start streaming. We're using the test video source, but you can use any other source.

```bash
gst-launch -v videotestsrc ! vp8enc ! rtpvp8pay ! udpsink host=127.0.0.1 port=9001
```

Take note of the following information output to the console. We'll need that to play the stream.

```text
/GstPipeline:pipeline0/GstUDPSink:udpsink0.GstPad:sink: caps = application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)VP8-DRAFT-0-3-2, payload=(int)96, ssrc=(uint)1276425242, clock-base=(uint)4009186568, seqnum-base=(uint)60154
```

In a peer-to-peer application you will probably transmit the parameters after caps above using RTCP, or some other signaling mechanism such as SIP or XMPP.

### Receive and play the stream

Issue the following command to play the video stream

```bash
gst-launch udpsrc port=9001 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)VP8-DRAFT-0-3-2, payload=(int)96, ssrc=(uint)1276425242, clock-base=(uint)4009186568, seqnum-base=(uint)60154" ! rtpvp8depay ! vp8dec ! ffmpegcolorspace ! autovideosink
```

It really is that simple with GStreamer!
