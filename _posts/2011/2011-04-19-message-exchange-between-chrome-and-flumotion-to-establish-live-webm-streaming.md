---
layout: default
title: Message exchange between Chrome and Flumotion to establish live WebM streaming
tags: webm http request
comments: true
---

This post shows how Chrome requests a WebM stream, how an HTTP server such as Flumotion responds to the request, and the stream format used.

When Chrome, version 10 at time of writing, encounters a video tag with a WebM source, it sends the following request

```http
GET /webm-audio-video/ HTTP/1.1
Host: 192.168.2.2:9001
Connection: keep-alive
Accept: */*
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16
Accept-Encoding: gzip,deflate,sdch
Accept-Language: pt-BR,pt;q=0.8,en-US;q=0.6,en;q=0.4
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3
Range: bytes=0-<
```

The GET URI and Host header will depend on the request. Note the [Range](http://tools.ietf.org/html/draft-ietf-http-range-retrieval-00) header, a `0-` means the server should return all data. If you sniff this message exchange using Wireshark, you will see that this request goes to the HTTP host and port specified in the source URL. The server responds from a socket bound to any other randomly chosen port. That is how TCP works.

The response from a server to the above request may look like

```http
HTTP/1.0 200 OK
Date: Mon, 18 Apr 2011 18:37:20 GMT
Connection: close
Cache-control: private
Content-type: video/webm
Server: FlumotionHTTPServer/0.8.1
```

The server should start streaming WebM data at this point, but Chrome closes the TCP connection and makes the same request again, I am not sure why.

The container format used to stream WebM is based on the [Matroska](http://www.matroska.org/technical/diagram/index.html) container format. It can also be used for [live streaming](http://www.matroska.org/technical/streaming/index.html).

I used the [Node.js TCP proxy]({% link _posts/2011/2011-04-08-a-simple-tcp-proxy-in-node.js.md %}) to log the messages above.
