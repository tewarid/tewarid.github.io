---
layout: default
title: Transfer VP8 video stream over UDP using GStreamer
tags: vp8 stream udp gstreamer
comments: true
---

This post shows GStreamer commands required to stream VP8 video using UDP.

The UDP protocol does not guarantee that datagrams will be sent in the right order, or even that they will arrive, hence the need for a transport protocol such as [RTP]({% link _posts/2011/2011-04-14-stream-webm-video-over-rtp-with-gstreamer.md %}).

### Sending End

Execute

```bash
gst-launch -v videotestsrc horizontal-speed=1 ! vp8enc ! udpsink host=localhost port=9001
```

### Receiving End

Execute

```bash
gst-launch udpsrc port=9001 reuse=true caps=video/x-vp8,width=320,height=240,framerate=30/1,pixel-aspect-ratio=1/1 ! vp8dec ! ffmpegcolorspace ! autovideosink
```

You can run several instances of the command above, but only the last instance plays, the previous instances stop playing. Once you kill the last instance the one before that resumes video playback. I haven't figured out why, but I suspect it has go to do with how UDP sockets work.
