---
layout: default
title: WebKit/Gtk+ with WebGL on PandaBoard
tags: webkit gtk+ webgl pandaboard
comments: true
---

Posting this to share the build and test procedure with [Ubuntu 11.04](https://wiki.ubuntu.com/ARM/OMAP) on the PandaBoard (OMAP4). If you have never built Webkit/Gtk+ before take a look at [WebKit/GTK+ on Ubuntu]({% link _posts/2011/2011-07-08-webkit-gtk+-on-ubuntu.md %}).

[Download](https://www.webkitgtk.org/releases/) source for development version 1.5.2.

### Additional Ubuntu Packages

You'll need to `sudo apt-get install` the following packages. If you have installed `ubuntu-omap4-extras-graphics` and `ubuntu-omap4-extras-graphics-dev` packages from the TI OMAP4 extras respository then you don't need to install `libgles1-mesa-dev` and `libgles2-mesa-dev` below. You already have the hardware accelerated versions.

* libgail-3-dev
* mesa-common-dev
* libgl1-mesa-dev
* libglu1-mesa-dev
* libgles1-mesa-dev
* libgles2-mesa-dev
* libgstreamer0.10-dev
* libgstreamer-plugins-base0.10-dev
* libgtkglext1-dev

### Obtain Missing Headers

Assuming you are in the root folder called `webkit-1.5.2`, these are the steps to get the missing headers

```bash
cd ..
svn checkout http://svn.webkit.org/repository/webkit/trunk/Source/ThirdParty/ANGLE/ angleproject
svn checkout http://svn.webkit.org/repository/webkit/trunk/Source/WebCore/platform/graphics WebKit
cd webkit-1.5.2
cp ../angleproject/src/compiler/ExtensionBehavior.h Source/ThirdParty/ANGLE/src/compiler/
cp ../angleproject/src/compiler/glslang.h Source/ThirdParty/ANGLE/src/compiler/
cp ../WebKit/Extensions3D.h Source/WebCore/platform/graphics/</pre>
```

### Build

Configure the build

```bash
./configure --prefix=/usr --enable-webgl --enable-3d-rendering
```

Then execute

```bash
make
```

### Test

Execute Webkit/Gtk+ using `GtkLauncher` with the `--enable-webgl` flag, and access any of the [three.js](https://github.com/mrdoob/three.js) Context 3D demos. I get a crash with all Context 3D demos, Context 2D demos work.

```bash
./Programs/GtkLauncher --enable-webgl
```
