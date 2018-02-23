---
layout: default
title: Handling TCP keep-alive
tags: tcp keepalive network programming python
---

Keep-alives are useful in scenarios where either end of a TCP connection disappears without closing the session.

The following script in Python demonstrates sending a keep-alive message when there is no data activity for 60 seconds. If there is no response, 4 additional keep-alive messages are sent at intervals of 15 seconds. If none get a response, the connection is aborted.

{% gist 2ddb47bc0206f0ba37453f56e564e227 %}

Edit the IP address `192.168.0.120` and port to whatever works on your network.

Create a test TCP listener/server using netcat (nc on OS X) on machine with IP address specified in the script

```bash
netcat -l 192.168.0.120 8001
```

Next, run the script

```bash
python keepalive.py
```

It should establish a TCP connection with the listener. Interrupt the network by enabling a firewall, or powering off a router. You'll see the following when the connection times out

```text
Traceback (most recent call last):
  File "socket_test.py", line 39, in do_work
    req = sock.recv(10)
error: [Errno 110] Connection timed out
Other Socket err, exit and try creating socket again
```

On OS X or Windows, you can enable keep-alive but cannot set TCP_KEEPIDLE and other parameters. You'll get the following error message if you try to do so

```text
Traceback (most recent call last):
  File "socket_test.py", line 65, in &lt;module&gt;
    do_work()
  File "socket_test.py", line 19, in do_work
    sock.setsockopt(socket.SOL_TCP, socket.TCP_KEEPIDLE, 60)
AttributeError: 'module' object has no attribute 'TCP_KEEPIDLE'
```

Wireshark highlights keep-alive messages if TCP sequence number analysis is enabled.
