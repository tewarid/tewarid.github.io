---
layout: default
title: Color depth
tags: rfb protocol color depth bit shift rfc 6143
comments: true
---
# Color depth

While working with the [RFB protocol](https://tools.ietf.org/html/rfc6143), I came upon a situation where I receive 16-bit pixels, with red, green, and blue, each at 5-bit color depth i.e. each color value ranges from 0 to 31. I need to change each pixel to 24-bit color depth for displaying as a bitmap, or 8-bit for each of red, green, and blue. What works is left shifting each of the 5-bit colors by 3 bits so each color is represented by 8 bits.
