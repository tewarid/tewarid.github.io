---
layout: default
title: Getting latest version of Chromium Browser on Ubuntu
tags: chrome latest ubuntu
comments: true
---
# Getting latest version of Chromium Browser on Ubuntu

Add package source `ppa:chromium-daily/stable` to the repository in Synaptic Package Manager or using the CLI

```bash
sudo add-apt-repository ppa:chromium-daily/stable
```

Then refresh and update using Synaptic Package Manager or use the CLI

```bash
sudo apt-get update
sudo apt-get install chromium
```

The latest version of Chrome can be obtained from [Google](http://www.google.com/chrome).
