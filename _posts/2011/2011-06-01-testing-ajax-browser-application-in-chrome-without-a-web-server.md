---
layout: default
title: Testing Ajax browser application in Chrome without a web server
tags: ajax chrome file system
---

Chrome, by default, only allows access to Javascript code from pages served by a web server over the HTTP protocol. If you need to test from the file system, you can do so by specifying the `--allow-file-access-from-files` option to the Chrome executable.
