---
layout: default
title: Send output to X clipboard from the command line
tags: ubuntu clipboard xwindow
comments: true
---

On Ubuntu, install the `xclip` package.

Pipe output to `xclip -selection clipboard`

```bash
ls | xclip -selection clipboard
```
