---
layout: default
title: Edit binary files in Linux
tags: edit binary linux xxd
comments: true
---
# Edit binary files in Linux

In this post I'll mention how to edit binary files using vi and the utility xxd that is a part of vi.

## vi in hex mode

Use the xxd command by typing `:%!xxd`. Edit hex data. Quit hex mode with `:%!xxd -r`.

## Use xxd command

You can use the xxd command outside vi. If you have an existing binary file, you can convert it to hex

```bash
xxd -g 1 file.bin > file.hex
```

You can then edit the hex and convert it back to binary

```bash
xxd -r file.hex > file.bin
```

### Read from standard input

You can pipe standard input to xxd to convert hex to binary

```bash
echo "dead bead" | xxd -p -r > file.bin
```

Certain minimal versions of xxd require lowercase input - you can use sed to perform the conversion

```bash
echo "DEAD BEAD" | sed y/ABCDEF/abcdef/ | xxd -p -r > file.bin
```

Certain minimal versions of xxd require hex with 30 bytes per line - sed can help with that

```bash
echo "5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a" | sed 's/.\{60\}/&\n/g' | xxd -p -r > file.bin
```

### Create C static array from binary

One nice little thing that xxd does is to produce a C static array definition, very convenient for embedding resource files

```bash
xxd -i file.bin
```
