---
layout: default
title: Live WebM and the video tag for screen casting
tags: screen cast webm live stream nodejs javascript
---

In this post, I modify the Node.js script introduced in post [Stream live WebM video to browser using Node.js and GStreamer]({% link _posts/2011/2011-04-26-stream-live-webm-video-to-browser-using-node.js-and-gstreamer.md %}) to stream a screen cast using the following players on Windows 7 and Ubuntu 11

* Chrome 11 video tag
* FireFox 4 video tag
* Opera 11 video tag (only tested on Windows 7)
* VLC media player - standalone and using [VLC media player browser plugin](https://wiki.videolan.org/Documentation:WebPlugin/) for Firefox

The video source in the Node.js script needs to be changed from `videotestsrc` to `ximagesrc`. I also changed the `framerate` to `2/1`, `max-keyframe-distance` to `2` and `max-latency` to `0`, to get the best _liveness_ possible.

Overall, the audio/video in the browsers lags by about 2 to 4 seconds on the local host. VLC shows the lowest lag time.

In Opera 11, if you play the same live video in two separate video tags in succession, it seems to play from cache in the second tag, from the point the video began playing in the first tag.

All browsers cache video - if you pause then resume, the video plays from the point it was paused. If you want to implement a live TV broadcast experience, you will be better off implementing custom controls, where pause effectively stops the video, and resume starts the video stream all over again.
