---
layout: default
title: Will threads become a relic?
tags: thread task
---

Newer concurrency APIs have hidden the concept of threads. They instead expose task parallelism by applying the thread pool pattern, making migration from thread pools to other means of task parallelism easier. Some implementations expose asynchronous calls, doing away with the need to even create tasks. If the process has a single thread of execution, as in the case of Node.js, you don't have to bother with locks. Scaling is achieved using multiple processes and shared data.

Evidence of this change can be seen in several popular programming APIs

* Concurrency Utilities in Java
* Parallel Extensions for .NET framework, and C# async and await
* Grand Central Dispatch in OS X and iOS 4

Hopefully in the future we'll see tasks magically dispatched to dedicated co-processors such as [Epiphany](http://www.adapteva.com/products/silicon-devices/) and the GPU. 

All that leads me to conclude that threads will become a relic in most programming languages.
