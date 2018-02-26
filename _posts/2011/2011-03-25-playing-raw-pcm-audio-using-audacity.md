---
layout: default
title: Playing raw PCM audio using Audacity
tags:
---

[Audacity](http://audacity.sourceforge.net/) has always been my favorite tool to do simple sound editing. I turned to it to play raw PCM audio captured by a sniffer I am writing.

Here are the steps to import raw PCM audio in Audacity

1. Run Audacity

2. From the Project menu, select Import Raw Data...

    ![Import Raw Data](/assets/img/audacity-import-raw-data.jpg)

    _In newer versions of Audacity go to File menu, Import, Raw Data..._

3. Select file with PCM data

4. Audacity tries to best guess the parameters required for importation. You'll need to change some of them, at least the Sample Rate

    ![Import Raw Data Options](/assets/img/audacity-import-raw-data-options.jpg)

5. Click Import
