---
layout: default
title: Graph Databases by Ian Robinson, Jim Webber, Emil Eifrem; O'Reilly Media
tags: book review graph database nosql neo4j
comments: true
---

![Graph Databases](http://akamaicovers.oreilly.com/images/0636920028246/lrg.jpg)

This books lays a solid foundation for understanding what Graph Databases are all about. Implementation details are all based on Neo4J, except for a fleeting reference to Twitter's FlockDB when discussing scalability.

Chapters 1 and 2 provide an overview of Graph Databases, and compare them to Relational and NoSQL Databases. Appendix A provides a useful overview of different NoSQL databases.

Data modeling with Graph Databases is compared to relational databases in Chapter 3\. It also discusses the creation of domain models using an example from the Systems Management domain, and Cypher to create and query the models. Cross-domain modeling and common modeling pitfalls are also discussed.

Chapter 4 discusses data modeling for Neo4J in further detail, and demonstrates when to use nodes or relationships. Neo4J can be embedded into applications or deployed in server mode, benefits of each mode are discussed. Test-driven data model development with ImpermanentGraphDatabase Java class is also discussed.

Chapter 5 provides common real-world use cases and examples. Domains covered in detail include social networking, authorization and access control, and geo/logistics.

Chapter 6 discusses native graph processing and storage, with topics such as index-free adjacency for better query performance, and programmatic access to Neo4J database provided by the Kernel, Core, and Traverser APIs. Non-functional characteristics such as transactions (ACID properties), recoverability, availability, scale (capacity; latency; throughput) are also discussed.

Graph algorithms such as depth- and breath-first search, Dijkstra's algorithm, and A* algorithm are discussed in chapter 7\. Analyses based on these algorithms, and techniques from graph theory and social sciences, can be used to gain new insights from a domain. Social graph properties such as Triadic Closures, Structural Balance, and Local Bridges can be used to gain new insights into a social network.

I found the book extremely useful to understand what Graph Databases are all about.

I thank O'Reilly Media for providing the e-book to review.
