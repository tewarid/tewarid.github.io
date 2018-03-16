---
layout: default
title: Send content using PUT method
tags: c# http put file upload
comments: true
---

This post demonstrates how to send content to server from a client application written in C#. A typical REST API implements PUT methods to receive content from clients. I've been using [RestSharp](https://github.com/restsharp/RestSharp) for most REST requests, but this is one use case it [doesn't provide for](http://stackoverflow.com/questions/10158977/can-restsharp-send-binary-data-without-using-a-multipart-content-type/11886210).

It is fairly easy to implement using .NET's HttpClient class

```c#
Uri uri = ...
byte[] content = ...
string contentType = ... 

HttpClient client = new HttpClient();
ByteArrayContent httpContent = new ByteArrayContent(content);
httpContent.Headers.ContentType = new MediaTypeHeaderValue(contentType);
Task<HttpResponseMessage> put = client.PutAsync(uri, httpContent);
HttpResponseMessage response = put.Result;

Task<string> read = response.Content.ReadAsStringAsync();

if (response.StatusCode == HttpStatusCode.Created)
    // use read.Result
```
