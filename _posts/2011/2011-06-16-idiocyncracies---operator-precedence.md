---
layout: default
title: idioCyncracies - operator precedence
tags:
comments: true
---
# idioCyncracies - operator precedence

I get a tingle when I see C code such as

```c
while (*string != 0)
  putchar(*string++);
```

How do you suppose the compiler evaluates the expression `*string++`? Here's the [operator precedence table](http://en.wikipedia.org/wiki/Operators_in_C_and_C%2B%2B#Operator_precedence) to help you figure that out.
