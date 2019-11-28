---
layout: default
title: Restrict access to a resource using AutoResetEvent
tags: .net core dotnet autoresetevent
comments: true
---
# Restrict access to a resource using AutoResetEvent

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
                Console.WriteLine($"{DateTime.Now:mm:ss.fff} Resource available to task {t}");
                Thread.Sleep(TimeSpan.FromMilliseconds(new Random().Next(500, 2000)));
                resource.Set();
            }
        }
    }
}
```

Outputs, forever

```text
$ dotnet run
Created task t4
Created task t8
Created task t5
Created task t2
Created task main
Created task t1
Created task t3
Created task t7
Created task t6
16:49.467 Resource available to task t4
16:50.095 Resource available to task t8
Created task t9
Created task t10
16:51.396 Resource available to task t5
16:53.353 Resource available to task t2
16:55.219 Resource available to task t1
16:56.399 Resource available to task main
16:58.163 Resource available to task t3
16:59.954 Resource available to task t7
17:01.642 Resource available to task t6
17:03.454 Resource available to task t4
17:05.127 Resource available to task t9
17:05.700 Resource available to task t10
17:07.281 Resource available to task t8
17:08.479 Resource available to task t5
17:09.434 Resource available to task t2
17:09.946 Resource available to task t1
17:11.767 Resource available to task main
17:13.375 Resource available to task t3
```
