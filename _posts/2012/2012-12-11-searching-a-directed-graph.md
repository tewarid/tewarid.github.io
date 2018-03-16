---
layout: default
title: Searching a directed graph
tags: directed graph .net c# algorithm
comments: true
---

This post briefly describes a generic [directed graph](https://github.com/tewarid/net-directed-graph) depth-first search algorithm I wrote in C#.

### DirectedGraph class

I use the [dynamic](http://msdn.microsoft.com/en-us/library/dd264736.aspx) keyword to do run-time type checking, this is required so that I can use math operations (like addition) with the generic type. This, unfortunately, only works with .NET Framework 4.0 and beyond.

The Search method is where most of the action happens. It supports end criteria based on weight and depth. Weight is the total weight of all the edges along a path. Depth is the number of nodes after the node where the search starts. Finally, there is a boolean flag that stops search when a cycle is detected. Cycle detection is very rudimentary. It is equivalent to setting the depth to total number of nodes (with adjacent nodes) in the graph.

### LinkedList class

I use the `LinkedList` class extensively. Why did I write my own linked list? Who doesn't like writing their own linked list? Just kidding. The linked list class is doubly linked and also behaves like a stack.

### Cost

I have yet to analyze the cost of the search algorithm in big-O notation. Being brute-force depth-first search, it should have characteristics similar to those published in popular algorithm text books. Memory usage is something else I haven't evaluated. The use of recursion should limit it to relatively shallow depths.
