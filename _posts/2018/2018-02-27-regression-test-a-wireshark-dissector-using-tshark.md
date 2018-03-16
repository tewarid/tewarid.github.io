---
layout: default
title: Regression test a Wireshark dissector using tshark
tags: wireshark tshark dissector test regression
comments: true
---

This post shows how you can use some basic command line utilities, and [tshark](https://www.wireshark.org/docs/man-pages/tshark.html), to automate regression testing of a Wireshark dissector.

Create baseline test result

```bash
find . -name "*.pcap" -print -exec tshark -r {} -V \; > result.txt
```

This will run tshark on files in the current directory with the pcap extension, and write the output to `result.txt`.

To test regression, use diff

```bash
diff result.txt <(find . -name "*.pcap" -print -exec tshark -r {} -V \;)
```

Any output produced by the above could be a result of

1. A valid change - if so, update the baseline test result

2. A bug - create a bug report with the output

This should work on macOS, Linux, and on Windows in the Git Bash shell.
