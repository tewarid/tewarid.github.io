---
layout: default
title: History of file in Git repo
tags: git log path
comments: true
---

Who changed what, and when, in a file or folder in a Git repo? The following simple command is usually enough

```bash
git log --follow -p --decorate=full pathspec
```

Remove `-p` option if you don't want change diff.
