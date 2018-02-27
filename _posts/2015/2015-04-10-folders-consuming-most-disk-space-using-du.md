---
layout: default
title: Folders consuming most disk space using du
tags: du disk usage macos linux
---

du is available natively on almost all Linux distributions, and on Mac OS X. If you are in need of reclaiming disk space, and want to quickly find which folders to focus your attention on, run the following command

```bash
du -h -d 1
```

That will quickly list all the folders under the current folder and their disk space usage. Use the following command to check space left on each disk

```bash
df -h
```
