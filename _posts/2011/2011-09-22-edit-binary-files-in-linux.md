---
layout: default
title: Edit binary files in Linux
tags: edit binary linux xxd
comments: true
---

In this post I'll mention how to edit binary files using vi and the utility xxd that is a part of vi.

### vi in hex mode

Use the xxd command by typing `:%!xxd`. Edit hex data. Quit hex mode with `:%!xxd -r`.

### Using xxd command

You can use the xxd command outside vi. If you have an existing binary file, you can convert it to hex

```bash
xxd -g 1 file.bin > file.hex
```

You can then edit the hex and convert it back to binary

```bash
xxd -r file.hex > file.bin
```

One nice little thing that xxd does is to produce a C static array definition, very convenient for embedding resource files

```bash
xxd -i file.bin
```
