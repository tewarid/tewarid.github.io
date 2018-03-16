---
layout: default
title: Publish a live screen capture
tags: live video screen capture
comments: true
---

There are several web-based conferencing solutions in the market, but if you would like to quickly screencast something on your own, this post may be helpful. Due to the tools we use, a Windows 32-bit PC is required.

You'll need the following

- [VH Screen capture](http://www.splitmedialabs.com/download) driver

    This is a (free for private use) driver that makes your screen or a window appear as an imaging device to Adobe Flash.

- [Flash media server](http://www.adobe.com/products/flashmediaserver/)

    The development server is free to use for testing purposes.

- [Flash media live encoder](http://www.adobe.com/products/flashmediaserver/flashmediaencoder/)

    This encodes video and audio and pushes it to Flash Media Server. You can stream simultaneously in several bit-rates if so desired.

- [Moyea](http://www.playerdiy.com/) Web Player

    You can use this to play streaming video.

Here are the steps you have to go through

1. Install all of the above.

2. Launch the _Configure VHScrCap_ utility to configure how you would like screen capture to happen. The driver can capture the entire screen or a window, you can change the output size, maintain aspect ratio, and so on.

3. Launch the Adobe Flash Media Live encoder, and choose VHScrCap as you video device. You can choose an audio device if you want to stream audio along with the video. Choose the video settings as required. To transmit the video stream check _Stream to Flash Media Server_, set the FMS URL as `rtmp://localhost/live`, stream name to `livestream`, and click _Connect_. Clicking _Start_ will stream the video to the Flash media server installation on your PC.

4. Launch Moyea Web Player on another machine, and add an RTMP stream with the URL `rtmp://localhost/live/livestream`, to watch the live stream. You can also create a customized media player and provide it to those who will watch your live stream.

I would like to test-drive IIS Live Smooth Streaming support for doing the same thing. The only problem is that Microsoft Expression Encoder with live smooth streaming support using H.264 is a paid product. If ever I get a copy of it, I'll try setting up live screen capture using it, and report the experience. Stay tuned!
