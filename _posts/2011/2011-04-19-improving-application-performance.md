---
layout: default
title: Improving application performance
tags: software performance profiling
comments: true
---
# Improving application performance

As Tom DeMarco [says](http://en.wikiquote.org/wiki/Tom_DeMarco)

_You can’t control what you can’t measure_.

To get into the right spirit for a performance improvement initiative know that you'll have to

* Learn
* Test and Measure
* Establish and evolve patterns and practices

Application performance is limited by

* CPU time
* Memory size
* Memory latency and throughput
* Storage size
* Storage latency and throughput
* Network latency and throughput
* Latency and throughput of I/O devices such as GPU

Benchmark above aspects using standard routines. Save results in operations per second (ops). Reuse the routines across different hardware and software configurations.

The following can be useful to find hotspots in a huge code base

* Memory profiler
* CPU profiler
* Counters
