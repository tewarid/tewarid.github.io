---
layout: default
title: WebKit/GTK+ on Ubuntu
tags: webkit gtk ubuntu
---

Ubuntu has fairly good independent browsers - FireFox and Chromium come to mind. If you want a cutting-edge WebKit port that is deeply integrated with the Ubuntu Desktop, [WebKit/Gtk+](http://live.gnome.org/WebKitGtk) is worth taking a look at. Its UI is based on Gtk and the multimedia playback is based on GStreamer.

### Obtain source code

Source can be downloaded from [webkitgtk.org](http://www.webkitgtk.org/?page=download). There are archives of the stable and development trees there.

### Build

You'll need to install the following packages (for the development tree at version 1.5.1) and any dependencies. Other packages may need to be installed for newer versions if `./configure` fails.

* bison
* flex
* gperf
* libjpeg8-dev
* libicu-dev
* libgail-dev
* libxt-dev
* libsoup2.4-dev
* libsqlite3-dev
* libxslt1-dev

Then, run the following commands

```bash
tar xvzf webkit-1.5.1.tar.gz
cd webkit-1.5.1
./configure
make
```

### Test

Run the browser using a simple helper program

```bash
./Programs/GtkLauncher
```

Open `http://www.youtube.com/html5`. Opt in to the html5 trial. Watch any video. WebM videos should play nicely on Ubuntu 11.04.

### Play video without start up lag

I am experimenting with HTTP streaming for real time communication (RTC). For that to work with no lag, I need the video tag to start playing the video immediately. I commented all lines of code that instructs the pipeline to enter the state `GST_STATE_PAUSED` in file `./Source/WebCore/platform/graphics/gstreamer/MediaPlayerPrivateGStreamer.cpp`.

For instance, this line in method `MediaPlayerPrivateGStreamer::pause()`

```c
    if (changePipelineState(GST_STATE_PAUSED))
        LOG_VERBOSE(Media, "Pause");
```

### Run GtkLauncher in fullscreen

To run GtkLauncher in fullscreen with no address and status bars, edit the source file `./Tools/GtkLauncher/main.c`.

In function `createWindow`, comment out the two lines shown within comments below

```c
    /*gtk_box_pack_start(GTK_BOX(vbox), createToolbar(uriEntry, webView), FALSE, FALSE, 0);*/
    gtk_box_pack_start(GTK_BOX(vbox), createBrowser(window, uriEntry, statusbar, webView), TRUE, TRUE, 0);
    /*gtk_box_pack_start(GTK_BOX(vbox), statusbar, FALSE, FALSE, 0);*/
```

Then, in function `main`, add the following line before the call to `gtk_main`

```c
    gtk_window_fullscreen((GtkWindow*)main_window);
```
