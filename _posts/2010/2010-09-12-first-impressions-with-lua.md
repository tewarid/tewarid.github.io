---
layout: default
title: First impressions with Lua
tags: lua programming
comments: true
---
# First impressions with Lua

I am not a big fan of arcane languages. When possible, I like to stick to mainstream languages. Sometimes, though, our work does drive us to some strange languages. Like [Visual TCL](http://www.amazon.com/exec/obidos/ISBN=013461674X/u/7141-5908756-107481), a toolkit for the SCO Unix operating system that I used in the final year of my BE degree.

I have mostly steered away from other popular languages such as Perl and Python. I started [learning](http://www.lua.org/pil/) Lua when my work required me to, quite skeptically at first, but I am fairly impressed by it.

I don't want this post to be long, so I'll quickly list those bits and pieces that are rarely seen in mainstream languages

* [Arrays](http://www.lua.org/pil/2.5.html) as tables of key/value pairs, or associative arrays

* [Multiple return](http://www.lua.org/pil/5.1.html) values from functions

* A [generic for loop](http://www.lua.org/pil/4.3.5.html), which in combination with multiple return values from functions, leads to some pretty strange possibilities

* [Named arguments](http://www.lua.org/pil/5.3.html) to functions using tables

* [Closures](http://www.lua.org/pil/6.1.html) and the ability to redefine any function, allowing for convenient [sandboxing](http://lua-users.org/wiki/ScriptSecurity)
