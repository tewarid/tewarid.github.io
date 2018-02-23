---
layout: default
title: Piping information within the browser
tags:
---

Every time I download a big file using a mobile browser, say a book, to upload it to another site, say Dropbox, I wish I could do it without requiring to touch the file system. There are some book sellers who provide Dropbox integration, but the number of cloud storage services has skyrocketed, and I don't think the sellers can integrate with each one of them. Some other standard mechanism is required.

If browsers provided a piping API, that allowed redirecting the download to just about any registered storage providers, including the standard Download location in the file system, that would probably solve this issue. The provider configuration could be specified in the settings. It could also be requested at the time of download.

I'll think further as to how this may be implemented without requiring any additional support from the browser.
