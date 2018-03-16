---
layout: default
title: SQL Server deadlock
tags:
comments: true
---

You have written a very useful enterprise application. All of a sudden users complain that data they entered is lost. You hurriedly start taking a look at the [SQL Server log](http://msdn.microsoft.com/en-us/library/ms187885.aspx) or run a trace using [SQL Profiler](http://msdn.microsoft.com/en-us/library/ms181091.aspx), and see the dreaded message:

```text
Error 1205 : Transaction (Process ID) was deadlocked on resources with another process 
and has been chosen as the deadlock victim. Rerun the transaction.
```

Quite obviously your code does not expect this error and does not rerun that transaction. You start [analyzing](http://msdn.microsoft.com/en-us/library/ms188246.aspx) the deadlock scenario, if you can reproduce it. After a while you reach the conclusion that you just can't change anything in those complex stored procedures that write data to the database.

In this particular scenario, one solution that did help me was to [lock](http://technet.microsoft.com/en-us/library/ms187373.aspx) the entire table using TABLOCK or TABLOCKX. It might seems like something really drastic to do, but if you have long running procedures, that hopefully do not exceed the timeout period of your database transaction, then it can be one quick-fix alternative.

You can use the [NOLOCK](http://www.codinghorror.com/blog/2008/08/deadlocked.html) hint on other SELECT queries so that they don't wait for your transaction to be committed, before returning useful results.

The long term solution is obviously more elaborate.

You can

* Optimize your queries or redesign your code (and requirements) so that the transaction time is as short as possible

* Detect transaction failures and rerun the transaction again

* Run long transactions at programmed downtimes
