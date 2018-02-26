---
layout: default
title: Stream raw vorbis audio over UDP or TCP with GStreamer
tags: audio vorbis stream tcp udp gstreamer
---

I have [posted]({% link _posts/2011/2011-05-03-stream-webm-vorbis-audio-using-gstreamer-over-tcp.md %}) before about streaming a vorbis audio stream using TCP, muxed as WebM, so that the container header provides the necessary information regarding the audio stream to the receiver. I have also [posted]({% link _posts/2011/2011-05-11-audio-streaming-over-rtp-using-the-rtpbin-plugin-of-gstreamer.md %}) about streaming raw audio using RTP over UDP. All that works fine, but I wanted to try doing the same using just UDP or TCP, without resorting to a container format or other protocol.

### Using UDP

The receiver starts the pipeline first, so it can receive the right headers

```bash
gst-launch -v udpsrc port=9001 ! vorbisdec ! audioconvert ! alsasink sync=false
```

The sender then starts a pipeline thus

```bash
gst-launch -v autoaudiosrc ! audioconvert ! audioresample ! vorbisenc ! multiudpsink client="localhost:9001,localhost:9002"
```

I have used a `multiudpsink` to demonstrate that it is possible to stream to multiple receivers. If you don't have a sound input device, you may try using the `audiotestsrc`. The neat thing about using UDP is that the sender can be stopped and started again, without affecting the receiver. Note the use of `sync` property in the `alsasink` element. If you set it to true, the audio stops playing after a while or does not begin playing.

If you initiate the receiver pipeline after the sender, you'll see a message such as

```text
ERROR: from element /GstPipeline:pipeline0/GstVorbisDec:vorbisdec0: Could not decode stream.
Additional debug info:
gstvorbisdec.c(976): vorbis_handle_data_packet (): /GstPipeline:pipeline0/GstVorbisDec:vorbisdec0:
```

### Using TCP

Now, one would think that replacing the `udpsrc` and `udpsink` above, with `tcpserversrc` and `tcpclientsink` respectively, would work just fine. Unfortunately, that is not so. I haven't arrived at a good explanation for it yet. I suspect it has to do with caps, so I use `gdppay` and `gdpdepay` in the pipeline below. Any GStreamer plugin hacker who can explain this difference between UDP and TCP is welcome to comment below.

The receiver can run a pipeline such as

```bash
gst-launch -v tcpserversrc port=9001 ! gdpdepay ! vorbisdec ! audioconvert ! alsasink sync=false
```

The sender can then start sending the audio stream, using a pipeline such as

```bash
gst-launch -v autoaudiosrc ! audioconvert ! audioresample ! vorbisenc ! gdppay ! tcpclientsink port=9001
```

One immediate advantage of using gdp with TCP, the sender can stream data using a `tcpserversink`, which can be received by multiple clients using `tcpclientsrc`. So, you are able to start the sender before the receiver.

The TCP pipelines above will not work with UDP. On executing the sender pipeline, the receiver prints a message such as

```text
gstgdpdepay.c(416): gst_gdp_depay_chain (): /GstPipeline:pipeline0/GstGDPDepay:gdpdepay0:
Received a buffer without first receiving caps
```
