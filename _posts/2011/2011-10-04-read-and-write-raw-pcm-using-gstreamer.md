---
layout: default
title: Read and write raw PCM using GStreamer
tags: pcm wav gstreamer
---

Embedded developers have a frequent need to encode or decode PCM audio. In this post I show some GStreamer pipelines that can help with that task.

### Convert WAV to PCM

```bash
gst-launch filesrc location=file.wav ! wavparse ! audioresample ! audioconvert ! audio/x-raw-int, rate=8000, channels=1, endianness=4321, width=16, depth=16, signed=true ! filesink location=file.pcm
```

For bulk conversion

```bash
ls *.wav | xargs -i -n 1 gst-launch filesrc location='{}' ! wavparse ! audioresample ! audioconvert ! audio/x-raw-int, rate=8000, channels=1, endianness=4321, width=16, depth=16, signed=true ! filesink location='{}'.pcm
```

### Convert PCM to WAV

```bash
gst-launch filesrc location=file.pcm ! audio/x-raw-int, rate=8000, channels=1, endianness=4321, width=16, depth=16, signed=true ! audioconvert ! audio/x-raw-int, rate=8000, channels=1, endianness=1234, width=16, depth=16, signed=true ! wavenc ! filesink location=file.wav
```

### Play PCM

```bash
gst-launch filesrc location=file.pcm ! audio/x-raw-int, rate=8000, channels=1, endianness=4321, width=16, depth=16, signed=true ! pulsesink
```

### Use xxd to create C array of PCM data

```bash
xxd -i file.pcm > voice.c
```
