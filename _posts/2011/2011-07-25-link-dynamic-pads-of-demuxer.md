---
layout: default
title: Link dynamic pads of demuxer
tags: gstreamer dynamic pad link
comments: true
---
# Link dynamic pads of demuxer

Demuxers do not have any pads till they receive the buffers to parse. As data is available to parse, pads are dynamically added based on the streams available.

## The `pad-added` signal

The `pad-added` [signal](https://developer.gnome.org/gobject/stable/signal.html) can be used to attach new elements to the pipeline when a new pad gets added. Use the [`g_signal_connect`](https://developer.gnome.org/gobject/stable/gobject-Signals.html#g-signal-connect) function to listen for `pad-added`. In the callback function, you can add new elements to the pipeline and link them to the demuxer based on the name of the pad. If the pad name starts with `audio`, for instance, you can link the element for audio playback. The state of these new elements needs to set to `GST_STATE_PLAYING`.

Here's how you can register a callback for `pad-added`

```c
g_signal_connect (demux, "pad-added", (GCallback)demux_pad_added, NULL);
```

Here's a sample callback function for the `matroskademux` element

```c
void
demux_pad_added (GstElement* demux, GstPad* pad, gpointer user_data)
{
  char* name;
  GstPad *sinkpad;
  GstElement *tee, *sink;

  name = gst_pad_get_name(pad);

  if (strncmp(name, "audio", 5) == 0)
  {
    // link audio sink pad of demuxer to src pad of audio tee
    tee = gst_element_factory_make ("tee", "audiotee");
    sink = gst_element_factory_make ("fakesink", "audiosink");
    gst_bin_add_many (GST_BIN (pipeline), tee, sink, NULL);
    gst_element_link (tee, sink);
    sinkpad = gst_element_get_static_pad(tee, "sink");
    gst_pad_link(pad, sinkpad);
    gst_object_unref (sinkpad);
    gst_element_set_state(tee, GST_STATE_PLAYING);
    gst_element_set_state(sink, GST_STATE_PLAYING);
    g_print ("Linked pad %s of demuxer\n", name);
  }
  else if (strncmp(name, "video", 5) == 0)
  {
    // link src pad of demuxer to sink pad of video tee
    tee = gst_element_factory_make ("tee", "videotee");
    sink = gst_element_factory_make ("fakesink", "videosink");
    gst_bin_add_many (GST_BIN (pipeline), tee, sink, NULL);
    gst_element_link (tee, sink);
    sinkpad = gst_element_get_static_pad(tee, "sink");
    gst_pad_link(pad, sinkpad);
    gst_object_unref (sinkpad);
    gst_element_set_state(tee, GST_STATE_PLAYING);
    gst_element_set_state (sink, GST_STATE_PLAYING);
    g_print ("Linked pad %s of demuxer\n", name);
  }

  g_free (name);
}
```

## The `no-more-pads` signal

Another signal that can be used is `no-more-pads`. You can check for its existence with your version of GStreamer by using `gst-inspect` e.g. `gst-inspect avidemux`. In the callback of that signal you can link new elements to the demuxer using `gst_element_link_filtered`. Call the function once for each caps. The caps parameter required by the function can be created using `gst_caps_new_simple` e.g. `gst_caps_new_simple ("video/x-vp8", NULL)`. Again, the state of these new elements needs to be set to `GST_STATE_PLAYING`.

Here's how you can register a callback for `no-more-pads`

```c
  g_signal_connect (demux, "no-more-pads", (GCallback)demux_no_more_pads, NULL);
```

Here's a sample callback function

```c
void
demux_no_more_pads (GstElement* demux, gpointer user_data)
{
  GstCaps *caps;
  GstElement *tee, *sink;

  tee = gst_element_factory_make ("tee", "videotee");
  sink = gst_element_factory_make ("fakesink", "videosink");
  gst_bin_add_many (GST_BIN (pipeline), tee, sink, NULL);
  gst_element_link (tee, sink);
  caps = gst_caps_new_simple ("video/x-vp8", NULL);
  gst_element_link_filtered (demux, tee, caps);
  gst_element_set_state(tee, GST_STATE_PLAYING);
  gst_element_set_state(sink, GST_STATE_PLAYING);

  tee = gst_element_factory_make ("tee", "audiotee");
  sink = gst_element_factory_make ("fakesink", "audiosink");
  gst_bin_add_many (GST_BIN (pipeline), tee, sink, NULL);
  gst_element_link (tee, sink);
  caps = gst_caps_new_simple ("audio/x-vorbis", NULL);
  gst_element_link_filtered (demux, tee, caps);
  gst_element_set_state(tee, GST_STATE_PLAYING);
  gst_element_set_state(sink, GST_STATE_PLAYING);
}
```

## Debugging

As usual, if you have any issues you need to troubleshoot with your pipeline, you can try setting the environment variable `GST_DEBUG` to `5`. GStreamer and its elements will print copious amounts of information as they execute.

```bash
export GST_DEBUG=5
```
