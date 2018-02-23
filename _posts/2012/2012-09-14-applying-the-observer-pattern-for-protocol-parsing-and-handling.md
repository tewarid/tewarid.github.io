---
layout: default
title: Applying the observer pattern for protocol parsing and handling
tags: observer network programming design
---

If you have done any network programming, interfacing two computing devices using some kind of network, you have had to deal with a protocol of some kind. Most protocols have a standard, fixed-size, header, and a variable payload, which may itself contain another protocol.

Let's take the IP protocol as an example. The IP version 4 protocol header has 20 bytes, but the payload is usually another protocol, such as TCP or UDP. The protocol itself is hinted at by a 8-bit Protocol field in the IPv4 header. Somewhere in an operating system kernel, a handler for the IP protocol has to invoke handlers for all the different protocols in the payload. This is something that cannot be hard-coded, otherwise for every new protocol the whole code-base would have to be rebuilt and deployed.

The Observer is the classic pattern applied in such a situation. For instance, the observer for the TCP protocol can register itself with the handler for the IPv4 protocol, receive and process messages, and deregister at will. Similarly, application specific observers can register with the TCP protocol observer (handler now) to receive or send messages on a particular port. In situations where a hint, such as a protocol or port number, is not possible, multiple observers can receive messages in a chain, process it, discard it, or suppress it from other observers down the chain. These are often referred to as filters.

Storing and retrieving observers can be achieved using well-known data structures. If the observer can be found using a hint or key, it can be stored in a hash table for fast lookup. If multiple observers need to be called, they can be stored in a list. If they need to be called in a particular order, a queue, stack, or a priority queue, can be used.

Every programming language provides some means of creating and using observers. Procedural languages like C allow calling functions using pointers, referred to as callbacks. Object-oriented languages can create observers as objects that implement a particular interface. Try and avoid using observer, handler, or filter, in the name of the class. Name it based on its intended function or purpose. After a while, it gets tiring to see the same words repeated ad nauseam.
