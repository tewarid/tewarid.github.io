---
layout: default
title: Common calls in a communications API
tags: software design
---

Inspired by several generic interfaces in the Unix/Linux world such as the socket API, and event-driven programming, I have been using the following calls (functions or methods, and event notifications) in my communications APIs

* `init`

    May be replaced by the constructor of a class. Creates resources that are held for the lifetime of this object. A corresponding call `destroy` may also be implemented for deterministic finalization of resources.

* `connect(configuration, callback)`

    Where `configuration` provides whatever configuration information is required for connection. It may also be passed to `init` or obtained by some other means. `callback` is invoked when connection is established. If implementing a server API, use `onConnect` for notification of incoming connection.

* `onConnect(connection)`

    Event notification when an incoming connection is established.

* `disconnect(callback)`

    Finalizes communication, and calls callback when done. In a server API `disconnect` may receive an additional parameter indicating which connection to disconnect from.

* `onDisconnect()`

    Event notification when a disconnection happens and `disconnect` has not been invoked.

* `onReceive(data)`

    Event notification when incoming data is received.

* `send(data)`

    Called when data needs to be sent. If data is an array of bytes, it may receive additional parameters such as start `index` and `length`. It may additionally receive a callback that is called when data is sent out (if the API buffers data).

* `onError(error)`

    Event notification when an `error` needs to be communicated.

Event notifications can be implemented differently in various languages. I have used callback function in C, delegates in .NET, event listeners (observers) in Java, Blocks in Objective C, and EventEmitter in Node.js.
