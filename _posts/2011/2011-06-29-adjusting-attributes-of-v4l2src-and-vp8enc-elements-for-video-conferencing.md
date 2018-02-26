---
layout: default
title: Adjusting attributes of v4l2src and vp8enc elements for video conferencing
tags: real time video vp8 webm
---

Video conferencing is real time in nature. The default encoding parameters of vp8enc element of GStreamer are not always appropriate. Let us start with the following pipeline

```bash
gst-launch v4l2src ! video/x-raw-rgb,width=320,height=240 ! ffmpegcolorspace ! vp8enc ! vp8dec ! ffmpegcolorspace ! ximagesink sync=false
```

The CPU usage, on a PandaBoard with Ubuntu 11.04, is close to 100% (since there are 2 cores, that translates to 50%).

Now, modify the pipeline as follows

```bash
gst-launch v4l2src decimate=3 ! video/x-raw-rgb,width=320,height=240 ! ffmpegcolorspace ! vp8enc speed=2 max-latency=2 quality=5.0 max-keyframe-distance=3 threads=5 ! vp8dec ! ffmpegcolorspace ! ximagesink sync=false
```

Note the `decimate` attribute of the `v4l2src` element, and the attributes `speed`, `max-latency`, `max-keyframe-distance`, `threads` and `quality` of the `vp8enc` element. With these changes the CPU usage drops to 40% and the video playback is more real time.
