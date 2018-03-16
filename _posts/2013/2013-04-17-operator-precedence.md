---
layout: default
title: Operator precedence
tags: c operator precedence programming
comments: true
---

Programmers should use parentheses more often. The following C language snippets are mind-blowing examples of when operator precedence is not obvious and can bite you.

```c
x & 0x01 == 0
```

Here, `==` is evaluated first and then `&`.

```c
a + b ^ c + d
```

Here, `*` is evaluated first and then `^`.

[SEI CERT C Coding Standard](https://www.securecoding.cert.org/confluence/display/c/SEI+CERT+C+Coding+Standard) actually have rules against depending on operator precedence, for instance [EXP00-C](https://www.securecoding.cert.org/confluence/display/c/EXP00-C.+Use+parentheses+for+precedence+of+operation).
