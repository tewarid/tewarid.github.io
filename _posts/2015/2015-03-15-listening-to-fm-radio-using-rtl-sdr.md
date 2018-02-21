---
layout: default
title: Listening to FM radio using RTL-SDR
tags: sdr software radio fm rtl-sdr sdr#
---

I am tinkering with an [RTL-SDR dongle](http://www.adafruit.com/products/1497) to listen to FM radio, on a MacBook Pro with OS X Yosemite, and a Windows 8.1 VM running on Parallels Desktop 10\. There are several software options available. I'll go into those that I tried, others that I didn't, and one that is surprisingly good.

## librtlsdr

This is a multi-platform library available as [open source](https://github.com/steve-m/librtlsdr). On Mac OS X, you can obtain it using homebrew

```bash
brew install librtlsdr
```

Here's how you can use the rtl_fm sample available with the library, to record wide-band [FM](http://www.radio-electronics.com/info/rf-technology-design/fm-frequency-modulation/what-is-fm-tutorial.php)

```bash
rtl_fm -f 88700000 -M wbfm - | ffmpeg -f s16le -ar 17000 -ac 2 -i - wbfm.wav
```

I pipe the output of rtl_fm, which is in signed 16-bit little-endian [PCM](http://wiki.audacityteam.org/wiki/WAV) format, to ffmpeg to produce a WAV file. The WAV file can then be played using Audacity, or any music player of your choice.

## SDR\#

[SDR#](http://sdrsharp.com/) is a Windows freeware that used to be open source in the past. It is fairly easy to listen to FM radio by following the [SDR# FM radio](https://learn.adafruit.com/getting-started-with-rtl-sdr-and-sdr-sharp/sdr-number-fm-radio) tutorial from Adafruit. The quality of audio is not so good on a Windows VM.

I attempted to build an older open source version of SDR# using Xamarin Studio for Mac OS X. It fails to run because run-time dependencies such as libsndfile and portaudio, installed through homebrew, are 64-bit binaries. 64-bit build of [mono](https://github.com/mono/mono) 3.12.0 and [libgdiplus](https://github.com/mono/libgdiplus) (the latter depends on cairo installed through homebrew) from source also does not work due to crash in native code invoked by System.Windows.Forms.XplatUICarbon.CGDisplayBounds. Windows Forms on 64-bit Mono on Mac OS X is currently a no-go.

There's [HDSDR](http://www.hdsdr.de/index.html), another Windows freeware, that I haven't tried. A Mac OS X port of [gnuradio](http://gnuradio.org/) is something else I want to try, but it is only available through MacPorts. I don't use MacPorts, and building gnuradio from source looks daunting due to the number of dependencies.

## Radio Receiver Chrome App

![Radio Receiver](/assets/img/chrome-radio-receiver.png)

The open source [Radio Receiver App](https://chrome.google.com/webstore/detail/radio-receiver/miieomcelenidlleokajkghmifldohpo?hl=en) from a developer at Google, is probably the best way to listen to FM radio using RTL-SDR. The sound quality is awesome, and it's mostly [implemented](https://github.com/google/radioreceiver) in JavaScript! How cool is that!?
