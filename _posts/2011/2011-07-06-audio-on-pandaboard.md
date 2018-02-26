---
layout: default
title: Audio on PandaBoard
tags: audio pandaboard alsa
---

There is a [workaround](http://groups.google.com/group/pandaboard/browse_thread/thread/e8f149e21d9b5a12) to enable audio on PandaBoard.

Execute the following commands and reboot

```bash
sudo alsaucm set _verb HiFi 
sudo alsaucm set _verb Record 
sudo rm /var/lib/alsa/asound.state
```
