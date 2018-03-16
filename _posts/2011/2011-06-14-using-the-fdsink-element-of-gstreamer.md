---
layout: default
title: Using the fdsink element of GStreamer
tags: fdsink gstreamer native pipeline
comments: true
---

The `fdsink` element is useful because it can be used to write data directly to a socket. In this post, we'll see how to setup a listener for client connections and stream directly to the client socket using `fdsink`.

### Listen for incoming connections

The code below sets up a server socket to listen for incoming client connections. Once a client connects, we send the appropriate HTTP headers, and call the function that will stream data to the client socket using `fdsink`. You can find the [`make_socket`](https://www.gnu.org/s/libc/manual/html_node/Inet-Example.html) function in the GNU libc manual.

```c
gpointer
client_thread(gpointer data)
{
  int BUF_SIZE = 256;
  char buffer[BUF_SIZE+1];
  int client = (int)data;
  int ret;

  ret = read(client, buffer, BUF_SIZE);

  while(ret != -1)
  {
    buffer[ret] = 0;
    g_print("%s", buffer);
    if (ret > 3 && strncmp(buffer, "GET", 3) == 0)
    {
      send(client, "HTTP/1.0 200 OK\r\n", 17, 0);
      send(client, "Connection: close\r\n", 19, 0);
      send(client, "Content-Type: video/webm\r\n", 26, 0);
      send(client, "\r\n", 2, 0);

      //... create pipeline with fdsink
    }

    ret = read((int)data, buffer, BUF_SIZE);
  }
}

gpointer
server_thread(gpointer data)
{
  int sock, client;
  struct sockaddr_in addr;
  size_t size;

  g_print("Server thread started\n");

  sock = make_socket(9001);

  while(1)
  {
    if (listen (sock, 1) < 0)
    {
      g_printerr ("listener failed");
      exit (EXIT_FAILURE);
    }
    size = sizeof(addr);
    client = accept(sock, (struct sockaddr *)&addr, &size);

    if (client < 0)
    {
      g_printerr ("accept failed");
      continue;
    }

    g_print("connect from host %s, port %d.\n",
      inet_ntoa(addr.sin_addr),
      ntohs(addr.sin_port));

    g_thread_create(client_thread, (gpointer)client, TRUE, NULL);
  }
}
```

### Create listener in its own thread

The server above can be executed in its own thread - we use glib, thus

```c
  sthread = g_thread_create(server_thread, NULL, TRUE, NULL);
```

### Use fdsink to stream to socket

The following code snippet demonstrates how `fdsink` can be setup

```c
  sink = gst_element_factory_make ("fdsink", NULL);
  g_object_set (G_OBJECT (sink), "fd", client, NULL);
```

### Handling client removal in a dynamic pipeline

A client can disconnect without a warning, `fdsink` does not provide any mechanism to handle such as situation. The whole pipeline can end if a single client disconnects. Luckily, the `multifdsink` can be used in such a scenario, as it handles client disconnection more gracefully. The `num-fds` property can be polled to detect that there are no pending clients.

Create a `multifdsink` thus

```c
  sink = gst_element_factory_make ("multifdsink", NULL);
```

After starting the pipeline, add a new socket fd thus

```c
  g_signal_emit_by_name(sink, "add", client, G_TYPE_NONE);
```

The `multifdsink` element has a [bug](https://bugzilla.gnome.org/show_bug.cgi?id=645746) that causes 100% CPU usage, but has been fixed in version 0.10.33 of GStreamer.

### Headers

The following headers contain the declarations required to compile the code above

```c
#include <gst/gst.h>
#include <glib.h>
#include <sys/socket.h>
#include <netinet/in.h>
```

That's all there is to it.
