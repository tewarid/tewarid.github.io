---
layout: default
title: Handling TCP keep-alive
tags: tcp keepalive network programming python
comments: true
---
# Handling TCP keep-alive

Keep-alives are useful in scenarios where either end of a TCP connection disappears without closing the session.

The following script in Python demonstrates sending a keep-alive message when there is no data activity for 60 seconds. If there is no response, 4 additional keep-alive messages are sent at intervals of 15 seconds. If none get a response, the connection is aborted.

```python
import sys
import socket
import traceback
import time

def do_work():

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # timeout recv every 5 seconds
    sock.settimeout(5.0) 

    # check and turn on TCP Keepalive
    x = sock.getsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE)
    if (x == 0):
        print 'Socket Keepalive off, turning on'
        x = sock.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
        print 'setsockopt='+str(x)
        # overrides value (in seconds) shown by sysctl net.ipv4.tcp_keepalive_time
        sock.setsockopt(socket.SOL_TCP, socket.TCP_KEEPIDLE, 60)
        # overrides value shown by sysctl net.ipv4.tcp_keepalive_probes
        sock.setsockopt(socket.SOL_TCP, socket.TCP_KEEPCNT, 4)
        # overrides value shown by sysctl net.ipv4.tcp_keepalive_intvl
        sock.setsockopt(socket.SOL_TCP, socket.TCP_KEEPINTVL, 15)
    else:
        print 'Socket Keepalive already on'

    try:
        sock.connect(('192.168.0.120', 8001))

    except socket.error:
        print 'Socket connect failed!'
        traceback.print_exc()
        return

    print 'Socket connect worked!'
    while True:
        try:
            # read at most 10 bytes (or less)
            req = sock.recv(10)

        except socket.timeout:
            print 'Socket timeout, loop and try recv() again'
            continue

        except:
            traceback.print_exc()
            print 'Other Socket err, exit and try creating socket again'
            # break from loop
            break

        if req == '':
            # connection closed by peer, exit loop
            print 'Connection closed by peer'
            break

        print 'Received', req

    try:
        sock.close()
    except:
        pass   


if __name__ == '__main__':
    do_work()

# references
# http://tldp.org/HOWTO/html_single/TCP-Keepalive-HOWTO/
# http://www.digi.com/wiki/developer/index.php/Handling_Socket_Error_and_Keepalive
```

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
