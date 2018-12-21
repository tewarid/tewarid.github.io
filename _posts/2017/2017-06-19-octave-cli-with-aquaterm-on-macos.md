---
layout: default
title: Octave CLI with AquaTerm on macOS
tags: octave cli macos aquaterm
comments: true
---
# Octave CLI with AquaTerm on macOS

I'm in need of [AquaTerm](https://github.com/AquaTerm/AquaTerm) to plot graphics using gnuplot with [octave-cli](https://sourceforge.net/projects/octave/files). I'll use the following Octave command to produce a nice little graphical plot

```text
octave:1> sombrero
```

![Octave Sombrero Plot](/assets/img/octave-sombrero.png)

To install aquaterm using homebrew

```bash
brew cask install aquaterm
```

[Check](https://stackoverflow.com/questions/13786754/octave-gnuplot-aquaterm-error-set-terminal-aqua-enhanced-title-figure-1-unk) lib and headers are properly linked

```bash
ls /usr/local/lib/libaquaterm*
ls /usr/local/include/aquaterm/*
```

If that lists nothing, [run](https://github.com/AquaTerm/AquaTerm/blob/master/aquaterm/INSTALL)

```bash
ln -s /Library/Frameworks/AquaTerm.framework/Versions/A/AquaTerm /usr/local/lib/libaquaterm.dylib
ln -s /Library/Frameworks/AquaTerm.framework/Versions/A/AquaTerm /usr/local/lib/libaquaterm.1.1.1.dylib
mkdir /usr/local/include/aquaterm
ln -s /Library/Frameworks/AquaTerm.framework/Versions/A/Headers/* /usr/local/include/aquaterm/.
```

Install gnuplot with aquaterm

```bash
brew install gnuplot --with-aquaterm
```

Run gnuplot and check whether terminal is set to aqua

```text
$ gnuplot 

    G N U P L O T
    Version 5.0 patchlevel 6    last modified 2017-03-18

    Copyright (C) 1986-1993, 1998, 2004, 2007-2017
    Thomas Williams, Colin Kelley and many others

    gnuplot home:     http://www.gnuplot.info
    faq, bugs, etc:   type "help FAQ"
    immediate help:   type "help"  (plot window: hit 'h')

Terminal type set to 'aqua'
gnuplot> test
```

The test command should produce a nice little plot such as

![gnuplot test](/asset/img/gnuplot-test.png)

Prior versions of octave-cli e.g. 3.8.0 use gnuplot, so you don't have to do anything else. Newer versions of Octave e.g. 4.2.1 use a different [graphics toolkit](https://www.gnu.org/software/octave/doc/interpreter/Graphics-Toolkits.html)  that [leverages OpenGL](https://www.gnu.org/software/octave/doc/interpreter/Introduction-to-Plotting.html). You can switch to gnuplot as follows

```text
octave:1> graphics_toolkit ("gnuplot")
```