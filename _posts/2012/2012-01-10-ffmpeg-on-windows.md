---
layout: default
title: FFmpeg on Windows
tags: ffmpeg windows
---

A quick post to document how audio and video can be captured on Windows using [FFmpeg](http://ffmpeg.zeranoe.com/builds/) into different container formats like MKV, MP4 and WebM.

### List DirectShow devices

The following command lists the names of audio and video devices currently installed

```cmd
ffmpeg -list_devices true -f dshow -i dummy
```

### Capture from webcam and microphone

With container format mkv the default video codec is H.264 and audio codec is Vorbis. With the mp4 container format (change output.mkv to output.mp4) the video codec is H.264 and audio code is MPEG AAC. With the webm container format the video codec is the Google/On2 VP8 and audio codec is Vorbis.

```cmd
ffmpeg -f dshow -i video="video device name":audio="audio device name" -r 25 -s 320x240 output.mkv
```

I added the `-s` video size and `-r` video frame rate options because I was getting lots of dropped frames with mkv and mp4.

**Reference** [ffmpeg directshow](http://betterlogic.com/roger/2011/08/ffmpeg-directshow/)
