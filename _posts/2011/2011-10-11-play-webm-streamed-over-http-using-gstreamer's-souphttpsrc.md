---
layout: default
title: Play WebM streamed over HTTP using GStreamer's souphttpsrc
tags: http stream souphttpsrc
comments: true
---
# Play WebM streamed over HTTP using GStreamer's souphttpsrc

The pipeline below receives WebM video using `souphttpsrc` and plays it

```bash
gst-launch-1.0 souphttpsrc location=http://127.0.0.1:9001 ! matroskademux ! vp8dec ! videoconvert ! autovideosink
```

Check the manual page for `souphttpsrc` or the `gst-inspect-1.0` output for the element, for further details.
