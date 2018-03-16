---
layout: default
title: Audio streaming over RTP using the rtpbin plugin of GStreamer
tags: audio rtp stream rtpbin gstreamer speex
comments: true
---

This post shows how you can do audio streaming over RTP using the gstrtpbin plugin, as discovered from the [RTP examples](http://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/tests/examples/rtp) published by GStreamer. I am using the [speex codec](http://www.speex.org/).

### Receiving end

```bash
gst-launch -v gstrtpbin name=rtpbin udpsrc caps="application/x-rtp,media=(string)audio,clock-rate=(int)44100,encoding-name=(string)SPEEX" port=5002 ! rtpbin.recv_rtp_sink_0 rtpbin. ! rtpspeexdepay ! speexdec ! audioconvert ! audioresample ! autoaudiosink udpsrc port=5003 ! rtpbin.recv_rtcp_sink_0 rtpbin.send_rtcp_src_0 ! udpsink port=5007 host=localhost sync=false async=false
```

### Sending end

```bash
gst-launch -v gstrtpbin name=rtpbin audiotestsrc ! audioconvert ! speexenc ! rtpspeexpay ! rtpbin.send_rtp_sink_0 rtpbin.send_rtp_src_0 ! udpsink port=5002 host=localhost rtpbin.send_rtcp_src_0 ! udpsink port=5003 host=localhost sync=false async=false udpsrc port=5007 ! rtpbin.recv_rtcp_sink_0
```

If you are using different machines at either ends, change `localhost` to hostname or IP address of the other machine.

This should work on a LAN or over the internet if you have a public IP address i.e. you are not behind a NAT - although you may be able to use port forwarding in the router, if you are.
