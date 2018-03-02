---
layout: default
title: Windows-1252 charset codes
tags: pandoc windows word html markdown
---

The following are some [Windows-1252](https://en.wikipedia.org/wiki/Windows-1252) (ISO 8859-1) charset codes I've seen in legacy HTML documents created in Word. The replacement suggestions are for conversion to UTF-8 characters available on the keyboard. Alternatively, you may want to use HTML [character entities](https://dev.w3.org/html5/html-author/charref).

`\x85` (ellipsis …) replace with three dots ...

`\x91` (curved quote ‘) replace with normal quote '

`\x92` (curved quote ’) replace with normal quote '

`\x93` (curved quote “) replace with normal quote "

`\x94` (curved quote ”) replace with normal quote "

`\x96` (dash –) replace with normal -

`\x97` (dash —) replace with normal -

`\xa0` (NBSP) replace with normal space

`\xa9` (copyright symbol ©) replace with (C)

`\xad` (soft hyphen) remove it

`\xae` (registered ®) replace with (R)

`\xb7` (dot ·) replace with an asterix *

You can use your favorite editor to search using regular expression sequence above, and replace.

Alternatively, use [GNU sed]() to automate file search and replace

```bash
gsed -i "s/\x94/'/g" file
```

This replaces all occurences of character with code 0x94 with a quote. `gsed` is GNU sed on macOS. `-i` does in place update to the file.
