---
layout: default
title: VP8 video streaming over RTP using the rtpbin plugin of GStreamer
tags: audio rtp stream rtpbin gstreamer vp8
comments: true
---

We have looked at streaming WebM VP8-encoded video using RTP in [Stream WebM video over RTP with GStreamer]({% link _posts/2011/2011-04-14-stream-webm-video-over-rtp-with-gstreamer.md %}). This post uses the gstrtpbin plugin of GStreamer, which eliminates the need to exchange RTP parameters out-of-band - using RTCP for that instead.

### Receiving end

Execute

```bash
gst-launch -v gstrtpbin name=rtpbin udpsrc caps="application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)VP8-DRAFT-0-3-2" port=5002 ! rtpbin.recv_rtp_sink_0 rtpbin. ! rtpvp8depay ! vp8dec ! ffmpegcolorspace ! autovideosink udpsrc port=5003 ! rtpbin.recv_rtcp_sink_0 rtpbin.send_rtcp_src_0 ! udpsink port=5007 host=localhost sync=false async=false
```

### Sending end

Execute

```bash
gst-launch -v gstrtpbin name=rtpbin videotestsrc ! video/x-raw-rgb,framerate=30/1 ! ffmpegcolorspace ! vp8enc speed=2 ! rtpvp8pay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 ! udpsink port=5002 host=localhost rtpbin.send_rtcp_src_0 ! udpsink port=5003 host=localhost sync=false async=false udpsrc port=5007 ! rtpbin.recv_rtcp_sink_0
```
