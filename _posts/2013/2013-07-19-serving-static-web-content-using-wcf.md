---
layout: default
title: Serving static web content using WCF
tags: wcf static content .net c# programming
comments: true
---
# Serving static web content using WCF

This post demonstrates how static web content can be served from a WCF service using WebHttpBinding and webHttp behavior.

## Service Interface

The service has just one method in its interface called StaticContent.

```c#
using System.IO;
using System.ServiceModel;

namespace WwwService
{
    [ServiceContract]
    interface IWwwService
    {
        [OperationContract]
        Stream StaticContent(string content);
    }
}
```

## Service Implementation

The implementation of the service is shown below. The StaticContent method returns a FileStream with the content of the requested resource, and sets the content type and HTTP status code.

```c#
using System;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.IO;

namespace WwwService
{
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
    public class WwwServiceImplementation : IWwwService
    {
        [WebInvoke(Method = "GET",
            BodyStyle = WebMessageBodyStyle.Bare,
            UriTemplate = "/{*content}")]
        public Stream StaticContent(string content)
        {
            OutgoingWebResponseContext response = WebOperationContext.Current.OutgoingResponse;
            string path = "www/" + (string.IsNullOrEmpty(content) ? "index.html" : content);
            string extension = Path.GetExtension(path);
            string contentType = string.Empty;

            switch (extension)
            {
                case ".htm":
                case ".html":
                    contentType = "text/html";
                    break;
                case ".jpg":
                    contentType = "image/jpeg";
                    break;
                case ".png":
                    contentType = "image/png";
                    break;
                case ".ico":
                    contentType = "image/x-icon";
                    break;
                case ".js":
                    contentType = "application/javascript";
                    break;
                case ".json":
                    contentType = "application/json";
                    break;
            }

            if (File.Exists(path) && !string.IsNullOrEmpty(contentType))
            {
                response.ContentType = contentType;
                response.StatusCode = System.Net.HttpStatusCode.OK;
                return File.Open(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            }
            else
            {
                response.StatusCode = System.Net.HttpStatusCode.NotFound;
                return null;
            }
        }
    }
}
```

You may want to add additional content types to the switch statement above, or implement an [externally configurable](http://refactoringaspnet.blogspot.com.br/2008/11/how-to-get-content-type-mimetype-of.html) mapping scheme.

## Hosting the service

Here's the App.config for the service.

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.serviceModel>
    <bindings>
      <webHttpBinding>
        <binding name="webHttpBinding"/>
      </webHttpBinding>
    </bindings>
    <behaviors>
      <endpointBehaviors>
        <behavior name="webHttp">
          <webHttp/>
        </behavior>
      </endpointBehaviors>
    </behaviors>
    <services>
      <service name="WwwService.WwwServiceImplementation">
        <endpoint address="http://localhost:8003/wwwservice" binding="webHttpBinding" bindingConfiguration="webHttpBinding" contract="WwwService.IWwwService" behaviorConfiguration="webHttp"/>
      </service>
    </services>
  </system.serviceModel>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.5"/>
  </startup>
</configuration>
```

Here's a console program that hosts the service configured above.

```c#
using System;
using System.ServiceModel;

namespace WwwService
{
    class Program
    {
        static void Main(string[] args)
        {
            ServiceHost host = new ServiceHost(typeof(WwwService.WwwServiceImplementation));
            host.Open();

            Console.WriteLine("Hit Enter to quit.");
            Console.ReadLine();
        }
    }
}
```

## Where to put static content

Create a folder called www inside the folder where the service is started, store your static content there, and name the default web page index.html. Then, when the browser requests content starting with the URL http://localhost:8003/wwwservice, it will be served static content by the StaticContent method, or returned a Not Found status code.
