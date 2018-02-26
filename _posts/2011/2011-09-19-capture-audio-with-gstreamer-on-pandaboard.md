---
layout: default
title: Capture audio with GStreamer on PandaBoard
tags: gstreamer pandaboard audio capture
---

In this post I list some of the audio devices from where sound can be captured on the PandaBoard with Ubuntu 11.04.

### Capture from a USB WebCam

To see the audio devices run the following command, or see cards listed by `pactl list`

```bash
cat /proc/asound/cards
```

Then execute a pipeline such as

```bash
gst-launch -v ! alsasrc device=hw2:0 ! audioconvert ! vorbisenc ! webmmux ! filesink location=audio.mkv
```

To capture using the `pulsesrc` element, switch to the appropriate audio input device in Sound Preferences then execute a pipeline such as

```bash
gst-launch -v ! pulsesrc ! audioconvert ! vorbisenc ! webmmux ! filesink location=audio.mkv
```

### Capture from desktop

Capture any sound currently being played. See sources listed by `pactl list` for device id.

To capture audio output source on the board, you'll need to switch to SDP4430 Analog Stereo sound output device in Sound Preferences, and use the device specified below

```bash
gst-launch -v ! pulsesrc device=alsa_output.platform-soc-audio.0.analog-stereo.monitor ! audioconvert ! vorbisenc ! webmmux ! filesink location=audio.mkv
```

To capture HDMI audio output source, you'll need to switch to PandaHDMI Analog Stereo sound output device in Sound Preferences, and use the device specified below

```bash
gst-launch -v ! pulsesrc device=alsa_output.platform-soc-audio.1.analog-stereo.monitor ! audioconvert ! vorbisenc ! webmmux ! filesink location=audio.mkv
```

### Capture from Line In

You'll need to switch to SDP4430 Analog Stereo sound input device in Sound Preferences. To capture sound from line in (upper 3.5 mm jack of the audio connector) execute

```bash
gst-launch -v ! pulsesrc ! audioconvert ! vorbisenc ! webmmux ! filesink location=audio.mkv
```
