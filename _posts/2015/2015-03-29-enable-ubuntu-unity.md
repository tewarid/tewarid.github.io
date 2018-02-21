---
layout: default
title: Enable Ubuntu Unity
tags: parallels desktop ubuntu unity
---

I have been having problems using Ubuntu Unity on my Parallels VM, that I was finally able to resolve with help from the Ubuntu forums. It turns out Ubuntu Unity Plugins was disabled for some reason. Use the following sequence of commands to run [CompizConfig Settings Manager](https://apps.ubuntu.com/cat/applications/compizconfig-settings-manager/).

```bash
sudo apt-get install compizconfig-settings-manager
export DISPLAY=:0
ccsm
```

Select Ubuntu Unity Plugin. Check Enable Ubuntu Unity Plugin if it is disabled. Enable other required plugins if you are prompted to do so.
