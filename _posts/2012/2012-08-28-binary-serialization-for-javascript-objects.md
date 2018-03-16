---
layout: default
title: Binary serialization for JavaScript objects
tags: binary serialization javascript programming
comments: true
---

One particular mechanism I find lacking in JavaScript is an easy, reusable, way to parse binary data. I have leveraged [custom attributes]({% link _posts/2011/2011-01-05-binary-serialization-in-.net-using-reflection.md %}) in the past in .NET. JavaScript does not provide custom attributes. One means of specifying the format of binary data is to use JSON. I tend to favor declarative mechanisms for writing reusable code.

I like it better when I can leverage open source code. Cross-pollination of ideas from other language communities can also provide interesting design ideas.

I found the following that I may use instead of writing my own parser

* [jParser](https://github.com/vjeux/jParser/)

    Read the [blog post](http://blog.vjeux.com/2011/javascript/binaryparser-unleash-javascript-power.html) about it from its author.

* [bitsyntax](https://github.com/squaremo/bitsyntax-js)

    Provides a neat syntax for parsing binary data, derived from [Erlang's bit syntax](http://www.erlang.org/doc/programming_examples/bit_syntax.html). I see examples for Node.js, I wonder if it works within the browser.

If you are looking for something similar for Ruby, you can take a look at [BinData](https://rubygems.org/gems/bindata).
