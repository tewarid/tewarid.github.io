---
layout: default
title: Stream live WebM video to browser using Node.js and GStreamer
tags: webm http live stream nodejs
---

We'll stream live WebM video to the browser using GStreamer and Node.js, in this post. Follow the procedure at [Build and install VP8 plugin and GStreamer]({% link _posts/2011/2011-04-07-live-webm-video-streaming-with-flumotion.md %}#build-and-install-vp8-plugin-and-gstreamer) to setup GStreamer 0.10.32. We'll use Node.js with the express middleware, that we used previously to [stream a WebM file]({% link _posts/2011/2011-04-25-stream-webm-file-to-chrome-using-node.js.md %}).

### The code

We spawn a GStreamer pipeline to mux a WebM stream, and stream it using the `tcpserversink` element. After we receive a request from the browser, at port 8001, we create a TCP client to receive the WebM stream, and forward it to the browser.

{% gist ebb075bbcbfb5c3d83dc7429647748a7 %}

### Run the code

Assuming you have saved the script to a file called `script.js`, run Node.js thus

```bash
node script.js
```

Now, you should be able to play the WebM stream in Chrome by accessing `http://localhost:8001/`.

### Debug

If you change the args to GStreamer and get a cryptic message such as

```text
execvp(): No such file or directory
```

Try tracing all system calls by executing Node.js with strace

```bash
strace -fF -o strace.log node livewebm.js
```

### Video and audio source elements

Here's a list of alternative video source elements

* autovideosrc

    Automatically detects and uses the default video source

* ksvideosrc

    Capture video from a webcam on Windows

* v4l2src

    Obtains video stream from a Video 4 Linux 2 device such as a webcam

* ximagesrc

    Creates video stream by capturing the screen

Here's a list of alternative audio source elements

* autoaudiosrc

    Automatically detects and chooses an audio source

* alsasrc

    Captures audio stream from a specific device, using alsa

* pulsesrc

    Captures audio stream from the default mic specified in system settings

An important point to note is that all these sources are live sources. GStreamer defines live sources as sources that produce data at a fixed rate and discard data when paused.
