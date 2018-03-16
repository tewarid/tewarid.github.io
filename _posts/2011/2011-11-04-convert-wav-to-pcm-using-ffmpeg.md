---
layout: default
title: Convert WAV to PCM using FFmpeg
tags: wav pcm ffmpeg
comments: true
---

[FFmpeg](http://ffmpeg.org/) has binaries for [Windows](http://ffmpeg.zeranoe.com/builds/). It is also available for Linux and other operating systems. That makes it more ubiquitous than GStreamer, which I have used for [PCM to WAV conversion]({% link _posts/2011/2011-10-04-read-and-write-raw-pcm-using-gstreamer.md %}) in the past.

Here's the command line for converting a WAV file to raw PCM. If your distribution provides Libav instead, replace `ffmpeg` with `avconv`.

```cmd
ffmpeg -i file.wav -f s16be -ar 8000 -acodec pcm_s16be file.raw
```

`s16be` indicates that the output format is signed 16-bit big-endian. The audio rate is changed to 8000 Hz.

You can import and play raw PCM using [Audacity]({% link _posts/2011/2011-03-25-playing-raw-pcm-audio-using-audacity.md %}).
