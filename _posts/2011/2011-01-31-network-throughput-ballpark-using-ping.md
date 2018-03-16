---
layout: default
title: Network throughput ballpark using Ping
tags: network throughput ping
comments: true
---

Can the humble ping (ICMP echo) be used to measure network throughput? There is  no good standard way to measure network throughput. Using different networking protocols and routers in the network can affect throughput considerably. I recently conducted a simple experiment to measure network throughput using ping.

I implemented a simple program in C# and compared the result with dedicated applications that measure throughput. It uses the Ping class from the .NET framework. We ping twice, once with the default buffer size and another time with a bigger buffer size. How big the buffer size is, is determined based on the response time. If the response time is too low, we increase the buffer size till be get a sufficiently high response time.

I then use the following formula to calculate the throughput in bits per second

$$
L \times 2 \times 1000 \times 8 \over (t_s - t_b)
$$

Where

| Variable |                          is                          |
| -------- | ---------------------------------------------------- |
| $$L$$    | buffer length                                        |
| $$t_s$$  | response time in milliseconds with small buffer size |
| $$t_b$$  | response time in milliseconds with big buffer size   |

Here's the source code

```c#
class Program
{
  const int TIMEOUT = 5000;
  const uint BUFFER_SIZE = 128;
  static byte [] buffer = new byte[BUFFER_SIZE];

  public static void Main (string[] args)
  {
    Ping ping = new Ping();
    long ts;
    long tb;
    while (true)
    {
      PingReply reply = ping.Send(args[0], TIMEOUT);

      Console.Clear();

      if (reply.Status != IPStatus.Success)
      {
        Console.WriteLine("Cannot ping: {0}", reply.Status.ToString());
        continue;
      }

      Console.WriteLine("Round trip time: {0} ms", ts=reply.RoundtripTime);

      reply = ping.Send(args[0], TIMEOUT, buffer);

      if (reply.Status != IPStatus.Success)
      {
        Console.WriteLine("Cannot ping: {0}", reply.Status.ToString());
        continue;
      }

      tb = reply.RoundtripTime;

      if (tb - ts <= 4)
      {
        if (buffer.Length*2 < 65500)
        {
          buffer = new byte[buffer.Length*2];
        }
        continue;
      }

      Console.WriteLine("Throughput with {0} byte buffer: {1:0} b/s\r",
      buffer.Length, (double)buffer.Length*2000*8 / (tb - ts));
      break;
    }
  }
}
```

Here's the output on a network between two PCs, each with a 100 megabit network card, and a switch between them.

```text
Round trip time: 1 ms
Throughput with a 32768 byte buffer: 87381333 bits/sec
```

The result of throughput measured using [Ixia QCHECK](http://www.tomsguide.com/us/qcheck,review-124.html) is

| Protocol | Throughput in Mbps |
| -------- | -----------------: |
| TCP      |             90.090 |
| UDP      |             38.096 |

I am wondering why the UDP throughput is consistently lower than the TCP throughput in those results. I'll leave that discovery for another post.
