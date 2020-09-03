---
layout: default
title: Create a Windows icon file using ImageMagick
tags: imagemagick ico icon windows
comments: true
---
# Create a Windows icon file using ImageMagick

A Windows 10 app [icon](https://docs.microsoft.com/en-us/windows/win32/uxguide/vis-icons) file contains four combinations of image size, alpha, bit depth, and colors. I find the open source [ImageMagick 7](https://imagemagick.org) particularly helpful, and here's a recipe for quickly creating an ico file, given a PNG file with enough resolution&mdash;I used one with 512x512 pixels, 32-bit depth, and alpha

```bash
convert $1 -resize 16x16   -depth 32 16-32.png
convert $1 -resize 32x32   -depth 32 32-32.png
convert $1 -resize 48x48   -depth 32 48-32.png
convert $1 -resize 256x256 -depth 32 256-32.png

convert 16-32.png 32-32.png 48-32.png 256-32.png $2
```

Save the above bash script and execute with the PNG file path followed by ico file path

```bash
./convert.sh image.svg icon.ico
```
