---
layout: default
title: Learning Node by Shelley Powers; O'Reilly Media
tags: book review
comments: true
---
# Learning Node by Shelley Powers; O'Reilly Media

![Learning Node](http://akamaicovers.oreilly.com/images/0636920024606/lrg.jpg)

Learning Node by [Shelley Powers](http://burningbird.net/) is timely, and should be on the reading list of every JavaScript and server-side developer. I have used [Node](http://nodejs.org/) on Linux for x86 and ARM, and Windows. Its performance, especially for network-intensive applications, has me astounded.

I'll briefly delve into things that stood out to me in each chapter of the book.

Chapter 1 is must read if you don't understand the asynchronous nature of Node. It also covers building it from source for Linux, and using [WebMatrix](http://www.microsoft.com/web/webmatrix/) to develop and run Node applications with IIS.

Chapter 2 shows how to use command line REPL (read-eval-print loop) to quickly test code, inspect objects, and as an _editor._ Imagine that!

Chapter 3 covers the Node core objects and modules. In particular, the [global](http://nodejs.org/api/globals.html) namespace object, process.nextTick to asynchronously execute a callback, [util](http://nodejs.org/api/util.html).inherits to implement inheritance, and [EventEmitter](http://nodejs.org/api/events.html) to emit events.

Chapter 4 covers the Node [module](http://nodejs.org/api/modules.html) system. Covers require and how it searches for modules (.js, .node or .json), delete require.cache to reload a module from source, how to create your own custom module, and expose its objects and functions using export. It also covers often used modules such as [npm](https://npmjs.org/) (installed with Node) for package management, [Optimist](https://github.com/substack/node-optimist) for options parsing, and [Underscore](https://github.com/documentcloud/underscore).

Chapter 5 delves deeper into the asynchronous nature of Node, covering control flow, exception handling, and asynchronous patterns. It then discusses the [Step](https://github.com/creationix/step) and [Async](https://github.com/caolan/async)modules that implement those patterns. It also briefly discusses Node coding style.

Chapters 6, 7, and 8 discuss web development middleware and frameworks such as [Connect](https://github.com/senchalabs/connect) and [Express](https://github.com/visionmedia/express), and templating modules that work in tandem with Express, such as [EJS](https://github.com/visionmedia/ejs) and [Jade](https://github.com/visionmedia/jade).

Chapters 9, 10, and 11 discuss the different means of persisting data, in a key-value store such as [Redis](http://redis.io/), document-centric database such as [MongoDB](http://www.mongodb.org/), or a relational database such as [MySQL](http://www.mysql.com/), either directly or using the [Sequelize](http://www.sequelizejs.com/) ORM.

Chapter 12 discusses manipulating PDF by executing external tools such as [PDF Toolkit](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/), creating drawings using the [canvas](https://github.com/LearnBoost/node-canvas) module, and streaming videos.

Chapter 13 discusses the popular [Socket.IO](http://socket.io/) library that you can leverage for bidirectional communication between server and the Browser.

Chapter 14 discusses unit testing, acceptance testing, and performance testing. Tools and modules covered include [Apache Bench](http://httpd.apache.org/docs/2.2/programs/ab.html) (ab), [nodeunit](https://github.com/caolan/nodeunit), [Selenium](http://seleniumhq.org/), and [soda](https://github.com/LearnBoost/soda). Also discussed is the [nodemon](https://github.com/remy/nodemon) module that can be used to restart the application when a script is changed.

Chapter 15 discusses TLS/SSL and HTTPS for securing data communication, saving password as hash using the [crypto](http://nodejs.org/api/crypto.html) module, authentication using the [passport](http://passportjs.org/) module, and authentication with Twitter using the [passport-twitter](https://github.com/jaredhanson/passport-twitter) Passport strategy module. It also discusses writing secure code by avoiding eval, validating data using a module such as [node-validator](https://github.com/chriso/node-validator), and running external scripts in a sandbox using the [vm](http://nodejs.org/api/vm.html) module.

Chapter 16 discusses deployment of applications to a server, or to the various cloud services such as Azure (using [Cloud9 IDE](https://c9.io/)), Joyent, Heroku, Amazon EC2, and Nodejitsu. It discusses modules such as Forever to recover from crashes, and integration with Apache. The discussion on clustering with Node is very brief and does not discuss the experimental [cluster](http://nodejs.org/docs/latest/api/cluster.html) module.

I am glad the author took the time to write this book, I am a better "Noder" because of it. I'd like to thank O'Reilly Media for giving me the opportunity to review this book as part of the blogger review program.
