---
layout: default
title: Simple message dispatcher using event delegates
tags: message messaging software design programming
---

This post demonstrates a simple asynchronous message dispatcher that decouples message producers from consumers. It leverages event delegates.

```c#
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;

namespace NetDispatcher
{
    public delegate void MessageHandler<U>(U message);

    public class MessageDispatcher<T, U>
    {
        static ConcurrentDictionary<T, System.Delegate> handlers =
            new ConcurrentDictionary<T, System.Delegate>();

        public static void Dispatch(T type, U message)
        {
            System.Delegate eventHandlers;
            handlers.TryGetValue(type, out eventHandlers);
            if (eventHandlers != null)
            {
                try
                {
                    List<Task> taskList = new List<Task>();
                    foreach (Delegate eventHandler in eventHandlers.GetInvocationList())
                    {
                        taskList.Add(Task.Run(delegate
                        {
                            ((MessageHandler<U>)eventHandler)(message);
                        }));
                    }
                    Task.WaitAll(taskList.ToArray());
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.Message);
                    Debug.WriteLine(ex.StackTrace);
                }
            }
        }

        public static void RegisterHandler(T type, MessageHandler<U> handler)
        {
            Delegate d;
            handlers.TryGetValue(type, out d);

            if (d == null)
            {
                handlers[type] = null;
            }

            handlers[type] = (MessageHandler<U>)handlers[type] + handler;
        }

        public static void DeregisterHandler(T type, MessageHandler<U> handler)
        {
            Delegate d;
            handlers.TryGetValue(type, out d);

            if (d != null)
            {
                handlers[type] = (MessageHandler<U>)handlers[type] - handler;
            }
        }
    }
}
```

This is how the message dispatcher may be used

```c#
// Register a handler for "foo" that accepts messages of type string
MessageDispatcher<string, string>.RegisterHandler("foo", delegate (string message)
{
    // ...
});

// Dispatch a message
MessageDispatcher<string, string>.Dispatch("foo", "bar");
```

The use of static methods with generic types allows it to be used for multiple message payload types.

See code and unit tests at [GitHub](https://github.com/tewarid/net-dispatcher).
