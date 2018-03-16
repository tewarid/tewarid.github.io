---
layout: default
title: GStreamer pipeline with Tee
tags: gstreamer tee tcp web stream
comments: true
---

The [`tee`](http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gstreamer-plugins/html/gstreamer-plugins-tee.html) element is useful to branch a data flow so that it can be fed to multiple elements. In this post, we'll use the `tee` element to split live, encoded, test video and audio sources, mux the output as live WebM, and stream the result using the [`tcpclientsink`](http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-base-plugins/html/gst-plugins-base-plugins-tcpclientsink.html) element. This procedure can be repeated several times to stream to multiple clients, the only limit being CPU usage and network bandwidth. By encoding only once, we avoid taxing the CPU - encoding being the most intensive operation it must perform. The code presented below has been tested with GStreamer 0.10.32.

### Creating a pipeline with Tee

Example C code that creates a dynamic GStreamer pipeline using `tee` follows

```c
  GstElement *pipeline, *videosrc, *colorspace, *videoenc,
    *videotee, *audiosrc, *conv, *audioenc, *audiotee;

  // Create elements
  pipeline = gst_pipeline_new ("tcp-streamer");
  videosrc = gst_element_factory_make ("videotestsrc", "videosrc");
  colorspace = gst_element_factory_make ("ffmpegcolorspace", "colorspace");
  videoenc = gst_element_factory_make ("vp8enc", "videoenc");
  videotee = gst_element_factory_make ("tee", "videotee");
  audiosrc = gst_element_factory_make ("autoaudiosrc", "audiosrc");
  conv = gst_element_factory_make ("audioconvert", "converter");
  audioenc = gst_element_factory_make ("vorbisenc", "audioenc");
  audiotee = gst_element_factory_make ("tee", "audiotee");

  if (!pipeline || !videosrc || !colorspace || !videoenc
    || !videotee || !audiosrc || !conv || !audioenc || !audiotee) {
    g_printerr ("One element could not be created.\n");
    return NULL;
  }

  // set the properties of elements
  g_object_set (G_OBJECT (videosrc), "horizontal-speed", 1, NULL);
  g_object_set (G_OBJECT (videosrc), "is-live", 1, NULL);
  g_object_set (G_OBJECT (videoenc), "speed", 2, NULL);

  // add all elements to the pipeline
  gst_bin_add_many (GST_BIN (pipeline),
    videosrc, colorspace, videoenc, videotee, audiosrc, conv,
    audioenc, audiotee, NULL);

  // link the elements together
  gst_element_link_many (videosrc, colorspace, videoenc,
    videotee, NULL);
  gst_element_link_many (audiosrc, conv, audioenc,
    audiotee, NULL);
```

### Branching from a Tee on a running Pipeline

We create a sub-pipeline using a bin. Creating a new branch from the `tee`, on a running pipeline, can be achieved thus

```c
  GstElement *bin, *videoq, *audioq, *muxer, *sink,
    *videotee, *audiotee;

  GstPad *sinkpadvideo, *srcpadvideo, *sinkpadaudio, *srcpadaudio;

  bin = gst_bin_new (NULL);
  videoq = gst_element_factory_make ("queue2", NULL);
  audioq = gst_element_factory_make ("queue2", NULL);
  muxer = gst_element_factory_make ("webmmux", NULL);
  sink = gst_element_factory_make ("tcpclientsink", NULL);

  if (!bin || !videoq || !audioq || !muxer || !sink) {
    g_printerr ("One element could not be created.\n");
    return FALSE;
  }

  g_object_set (G_OBJECT (muxer), "streamable", 1, NULL);

  g_object_set (G_OBJECT (sink), "port", port,
    "host", "localhost", NULL);

  gst_bin_add_many (GST_BIN (bin), videoq, audioq,
    muxer, sink, NULL);

  // link src pad of video queue to sink pad of muxer
  srcpadvideo = gst_element_get_static_pad(videoq, "src");
  sinkpadvideo = gst_element_get_request_pad(muxer, "video_%d");
  gst_pad_link(srcpadvideo, sinkpadvideo);

  // link src pad of audio queue to sink pad of muxer
  srcpadaudio = gst_element_get_static_pad(audioq, "src");
  sinkpadaudio = gst_element_get_request_pad(muxer, "audio_%d");
  gst_pad_link(srcpadaudio, sinkpadaudio);

  gst_element_link(muxer, sink);

  // Create ghost pads on the bin and link to queues
  sinkpadvideo = gst_element_get_static_pad(videoq, "sink");
  gst_element_add_pad(bin, gst_ghost_pad_new("videosink", sinkpadvideo));
  gst_object_unref(GST_OBJECT(sinkpadvideo));
  sinkpadaudio = gst_element_get_static_pad(audioq, "sink");
  gst_element_add_pad(bin, gst_ghost_pad_new("audiosink", sinkpadaudio));
  gst_object_unref(GST_OBJECT(sinkpadaudio));

  // set the new bin to PAUSE to preroll
  gst_element_set_state(bin, GST_STATE_PAUSED);

  // Request source pads from tee and sink pads from bin
  videotee = gst_bin_get_by_name (GST_BIN(pipeline), "videotee");
  srcpadvideo = gst_element_get_request_pad(videotee, "src%d");
  sinkpadvideo = gst_element_get_pad(bin, "videosink");
  audiotee = gst_bin_get_by_name (GST_BIN(pipeline), "audiotee");
  srcpadaudio = gst_element_get_request_pad(audiotee, "src%d");
  sinkpadaudio = gst_element_get_pad(bin, "audiosink");

  // Link src pad of tees to sink pads of bin
  gst_bin_add(GST_BIN(pipeline), bin);
  gst_pad_link(srcpadvideo, sinkpadvideo);
  gst_pad_link(srcpadaudio, sinkpadaudio);

  gst_element_set_state (pipeline, GST_STATE_PLAYING);
```

### Removing the branch from a running pipeline

The following code illustrates how to remove the sub-pipeline.

```c
  //gst_element_set_state (pipeline, GST_STATE_PAUSED);
  // pause pipeline if no more bins left
  gst_element_set_state (bin, GST_STATE_NULL);

  gst_pad_unlink(srcpadvideo, sinkpadvideo);
  gst_pad_unlink(srcpadaudio, sinkpadaudio);

  gst_element_remove_pad(videotee, srcpadvideo);
  gst_element_remove_pad(audiotee, srcpadaudio);

  gst_bin_remove(GST_BIN(pipeline), bin);

  //gst_element_set_state (pipeline, GST_STATE_PLAYING);
  // resume pipeline if there are bins left
```

For the curious, I cache the above pointers in a [`GHashTable`](http://developer.gnome.org/glib/unstable/glib-Hash-Tables.html) using port number as the key.
