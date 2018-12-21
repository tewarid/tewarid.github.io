---
layout: default
title: Points to remember regarding C pointers
tags: c pointer
comments: true
---
# Points to remember regarding C pointers

Some points to remember regarding C pointers

1. A pointer is like any value type, but the value it stores is an address, that is why pointers to any type have the same size i.e. value `return`ed by `sizeof` is the same.

2. A pointer can store the address of another pointer, thus the existence of `**`.

3. If defined within a function its scope is `auto`, it is created on the stack and _dies_ when the function `return`s.

4. If passed to another function i.e. _callee_, the value it stores i.e. the address it points to, is passed to the _callee_.

5. To gain access to the value it points to, a pointer has to be dereferenced, this is done by using the `*` operator.

6. A pointer that has a value of `0` is called a `null` pointer.

7. To get the address of any identifier, the `&` operator can be used. Don't pass pointer to a variable of scope `auto` to a _callee_ that may retain it for use at some future point in time. Once the _caller_ `return`s, the region of stack used by it is reclaimed, the _callee_ may read values that are, for all effects, junk.

8. Pointer arithmetic can be used to read array elements, when you add `n` to a pointer, you are traversing to the `n`<sup>th</sup> element in the array.

9. A pointer may be cast to a struct pointer, and the attributes of the struct read or written to. Beware of byte ordering i.e. endianness, and struct memory alignment, when you `memcpy` data between devices with different processor architectures. Usage of appropriate compiler directive, [`packed` attribute](http://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html) of GCC for instance, is recommended to prevent [padding](http://www.catb.org/esr/structure-packing/) from causing issues e.g.
    * `struct __attribute__ ((__packed__)) identifier {...` OR
    * `typedef struct {...} __attribute__ ((__packed__)) identifier...` OR
    * `#pragma pack(1)`

10. A `void *` is used to store the address of any arbitrary type.
