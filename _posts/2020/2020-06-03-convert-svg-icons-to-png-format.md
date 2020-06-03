---
layout: default
title: Convert SVG icons to PNG format
tags: librsvg rsvg convert imagemagick image
comments: true
---
# Convert SVG icons to PNG format

There are several good sources of royalty-free SVG icons such as [material.io](https://material.io/resources/icons/). You can download an icon in SVG format and quickly convert it to a PNG of practically any size&mdash;we use a width of 512 pixels in the examples below.

## Using `rsvg-convert`

```bash
rsvg-convert bluetooth-white-48dp.svg -h 512 -o bluetooth-white-512p.png
```

`rsvg-convert` is distributed with `librsvg` and can be installed on macOS using Homebrew

```bash
brew install librsvg
```

On Ubuntu, install package `librsvg2-bin`

```bash
sudo apt install librsvg2-bin
```

## Using ImageMagick

```bash
convert -density 1200 -resize 512x512 -background transparent bluetooth-white-48dp.svg bluetooth-white-512p.png
```
