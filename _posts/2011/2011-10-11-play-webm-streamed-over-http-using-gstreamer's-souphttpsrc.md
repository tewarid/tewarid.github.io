---
layout: default
title: Play WebM streamed over HTTP using GStreamer's souphttpsrc
tags: http stream souphttpsrc
comments: true
---

The pipeline below receives WebM video using `souphttpsrc` and plays it

```bash
gst-launch souphttpsrc location=http://127.0.0.1:9001 ! matroskademux ! vp8dec ! ffmpegcolorspace ! ximagesink
```

Check the manual page for `souphttpsrc` or the `gst-inspect` output for the element, for further details.
