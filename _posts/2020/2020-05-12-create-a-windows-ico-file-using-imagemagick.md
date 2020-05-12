---
layout: default
title: Create a Windows ico file using ImageMagick
tags: imagemagick ico icon windows
comments: true
---
# Create a Windows ico file using ImageMagick

Windows 10 [device metadata](https://docs.microsoft.com/en-us/windows-hardware/drivers/devapps/step-2--create-device-metadata) requires an icon file with 13 combinations of image size, alpha, bit depth, and colors. I found the open source [ImageMagick 7](https://imagemagick.org) particularly helpful. Here's a recipe for quickly creating an ico file, given a PNG file with enough resolution&mdash;I used one with 512x512 pixels, 32-bit depth, and alpha

```bash
convert $1 -resize 16x16   -depth 4   -colors 16  -alpha Remove 16-4.png
convert $1 -resize 16x16   -depth 8   -colors 256 -alpha Remove 16-8.png
convert $1 -resize 16x16   -depth 32                            16-32.png
convert $1 -resize 24x24   -depth 4   -colors 16  -alpha Remove 24-4.png
convert $1 -resize 24x24   -depth 8   -colors 256 -alpha Remove 24-8.png
convert $1 -resize 24x24   -depth 32                            24-32.png
convert $1 -resize 32x32   -depth 4   -colors 16  -alpha Remove 32-4.png
convert $1 -resize 32x32   -depth 8   -colors 256 -alpha Remove 32-8.png
convert $1 -resize 32x32   -depth 32                            32-32.png
convert $1 -resize 48x48   -depth 4   -colors 16  -alpha Remove 48-4.png
convert $1 -resize 48x48   -depth 8   -colors 256 -alpha Remove 48-8.png
convert $1 -resize 48x48   -depth 32                            48-32.png
convert $1 -resize 256x256 -depth 32                            256-32.png

convert 16-4.png 16-8.png 16-32.png 24-4.png 24-8.png 24-32.png 32-4.png 32-8.png 32-32.png 48-4.png 48-8.png 48-32.png 256-32.png $2
```

Save the above bash script and execute with the PNG file path followed by ico file path.
