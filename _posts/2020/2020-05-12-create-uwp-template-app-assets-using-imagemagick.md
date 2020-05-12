---
layout: default
title: Create UWP template app assets using ImageMagick
tags: imagemagick image assets windows uwp template studio
comments: true
---
# Create UWP app assets using ImageMagick

[Windows Template Studio](https://github.com/microsoft/WindowsTemplateStudio) can be used to quickly generate a UWP app for Windows 10. It places some initial assets in the Assets folder that need to be created. I found the open source [ImageMagick 7](https://imagemagick.org) particularly helpful in doing that. Here's a recipe for quickly creating the assets, given a PNG file with enough resolution&mdash;I used one with 512x512 pixels, 32-bit depth, and alpha

```bash
convert $1 -resize 48x48   -depth 32 LockScreenLogo.scale-200.png
convert $1 -resize 300x300 -depth 32 Square150x150Logo.scale-200.png
convert $1 -resize 88x88   -depth 32 Square44x44Logo.scale-200.png
convert $1 -resize 24x24   -depth 32 Square44x44Logo.targetsize-24_altform-unplated.png
convert $1 -resize 50x50   -depth 32 StoreLogo.png
convert $1 -resize 400x400 -background none -gravity center -extent 1240x600 -depth 32 SplashScreen.scale-200.png
convert $1 -resize 200x200 -background none -gravity center -extent 620x300  -depth 32 Wide310x150Logo.scale-200.png
```

Save the above bash script and execute with the PNG file path.
