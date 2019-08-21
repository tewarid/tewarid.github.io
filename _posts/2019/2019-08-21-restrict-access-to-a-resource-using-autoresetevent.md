---
layout: default
title: Restrict access to a resource using AutoResetEvent
tags: .net core dotnet autoresetevent
comments: true
---

The following .NET console application

```c#
using System;
using System.Threading;
using System.Threading.Tasks;

namespace ConsoleApp
{
    class Program
    {
        private static AutoResetEvent resource = new AutoResetEvent(true);

        static void Main(string[] args)
        {
            for (int i = 1; i <= 10; i++)
            {
                string t = $"t{i}";
                Task.Run(() =>
                {
                    doSomething(t);
                });
            }
            doSomething("main");
        }

        private static void doSomething(string t)
        {
            Console.WriteLine($"Created task {t}");
            while(true)
            {
                resource.WaitOne();
                Console.WriteLine($"Resource available to task {t}");
                Thread.Sleep(TimeSpan.FromSeconds(2));
                resource.Set();
            }
        }
    }
}
```

Outputs, forever

```text
$ dotnet run
Created task main
Created task t6
Created task t5
Created task t4
Created task t1
Created task t3
Created task t2
Created task t7
Created task t8
Resource available to task main
Created task t9
Created task t10
Resource available to task t6
Resource available to task t5
Resource available to task t4
Resource available to task t1
Resource available to task t3
Resource available to task t2
Resource available to task t7
Resource available to task t8
Resource available to task t9
Resource available to task t10
Resource available to task main
Resource available to task t6
Resource available to task t5
Resource available to task t4
```
