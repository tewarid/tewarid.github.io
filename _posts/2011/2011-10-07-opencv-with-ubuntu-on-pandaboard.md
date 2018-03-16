---
layout: default
title: OpenCV with Ubuntu on PandaBoard
tags: opencv ubuntu pandaboard
comments: true
---

This post is for those unfamiliar with OpenCV to obtain and build it for Ubuntu on PandaBoard.

### Source code

Obtain the bzipped [source package](https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/) for Unix. Extract it with `tar xvjf` so that the source folder is created, e.g. `OpenCV-2.3.1`.

### Additional packages

You'll need to have the following packages to configure the build. I'll assume you have the GNU compiler collection installed already.

* cmake
* cmake-qt-gui

### Configure build

Execute `cmake-gui` from the command line. Set the source and binaries folders (see figure below for reference). Choose the Unix Makefiles as the build generation mechanism. Configure as appropriate and generate the files required by `make`. You can build static libraries by unchecking the BUILD_SHARED_LIBS option.

![cmake GUI](/assets/img/opencv-cmake-gui.png)

### Build

Run `make` in the binaries folder. If all goes well, the binaries should be available in the `bin` folder and the libraries in the `lib` folder.

### Run samples

Try and run the drawing sample from the `bin` folder. Here's a screenshot of it running for reference.

![drawing demo](/assets/img/opencv-drawing-demo.jpg)
