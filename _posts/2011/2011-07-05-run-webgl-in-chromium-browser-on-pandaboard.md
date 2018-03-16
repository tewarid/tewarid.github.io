---
layout: default
title: Run WebGL in Chromium Browser on PandaBoard
tags: webgl chromium pandaboard gpu acceleration
comments: true
---

These are the steps to get up and running

1. Install [Ubuntu](https://wiki.ubuntu.com/ARM/OMAP) for OMAP4 [on an SD card]({% link _posts/2011/2011-06-27-write-ubuntu-image-file-to-sd-card-on-windows.md %})

2. Boot from SD card and complete setup

3. Install `ubuntu-omap4-extras-graphics` packages from the repository `ppa:tiomap-dev/release`

4. Install `chromium-browser` package - at version [10.0.648.205](https://launchpad.net/ubuntu/natty/armel/chromium-browser/10.0.648.205~r81283-0ubuntu1) currently

5. Reboot

6. [Run](https://bugs.launchpad.net/ubuntu/+source/chromium-browser/+bug/725567) `chromium-browser` with the `--use-gl=egl` command line switch. The `about:gpu` page should show that a GPU is present. You can use a GPU accelerated canvas by opening page `about:flags` and setting GPU Accelerated Canvas 2D to enabled.

7. Point to a site that has WebGL demos e.g. [three.js](https://github.com/mrdoob/three.js)

That's all folks!
