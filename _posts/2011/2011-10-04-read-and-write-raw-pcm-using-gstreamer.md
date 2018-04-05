---
layout: default
title: Read and write raw PCM using GStreamer
tags: pcm wav gstreamer
comments: true
---

Embedded developers have a frequent need to encode or decode PCM audio. In this post I show some GStreamer pipelines that can help with that task.

### Convert WAV to PCM

```bash
gst-launch-1.0 filesrc location=file.wav ! wavparse ! audioresample ! audioconvert ! audio/x-raw,format=S16BE,channels=1,rate=8000 ! filesink location=file.pcm
```

For additional raw formats, see [Raw Audio Media Types](https://gstreamer.freedesktop.org/documentation/design/mediatype-audio-raw.html).

For bulk conversion, try

```bash
find *.wav -exec gst-launch-1.0 filesrc location={} ! wavparse ! audioresample ! audioconvert ! audio/x-raw,format=S16BE,channels=1,rate=8000 ! filesink location={}.pcm \;
```

This should also work fine from Git Bash shell on Windows.

### Convert PCM to WAV

```bash
gst-launch-1.0 filesrc location=file.pcm ! audio/x-raw,format=S16BE,channels=1,rate=8000 ! audioconvert ! audio/x-raw,format=S16LE,channels=1,rate=8000 ! wavenc ! filesink location=file.wav
```

### Play PCM

```bash
gst-launch-1.0 filesrc location=file.pcm ! audio/x-raw,format=S16BE,channels=1,rate=8000 !
audioconvert ! audioresample ! autoaudiosink
```

### Use xxd to create C array of PCM data

```bash
xxd -i file.pcm > voice.c
```
