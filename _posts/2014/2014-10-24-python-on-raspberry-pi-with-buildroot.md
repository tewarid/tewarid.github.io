---
layout: default
title: Python on Raspberry Pi with Buildroot
tags: python buildroot raspberry pi linux
---

I'm in need of python on my custom embedded Linux system for Raspberry Pi. This post shows how I enable it. For some reason python build was failing with errors such as

```text
build error: unknown type name ‘wchar_t’
```

A clean build, as follows, resolved it

```bash
make clean
make
```

To add python to your Buildroot config, invoke

```bash
make menuconfig
```

Enable WCHAR support, under Toolchain

![WCHAR support](/assets/img/buildroot-toolchain-wchar.png)

Enable python or python3, under Target packages, Interpreter languages and scripting

![Python](/assets/img/buildroot-packages-python.png)
