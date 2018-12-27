---
layout: default
title: Cleaner JSON from a WCF service with webHttp behavior
tags: json wcf c# html jquery
comments: true
---
# Cleaner JSON from a WCF service with webHttp behavior

This post improves on an earlier post, [Consuming WCF services using JQuery JSON]({% link _posts/2011/2011-02-06-consuming-wcf-services-using-jquery-json.md %}). The JSON serialized by the WCF service in that post is wrapped inside a [d property](https://haacked.com/archive/2008/11/20/anatomy-of-a-subtle-json-vulnerability.aspx/). In this post we modify the service to return cleaner JSON by using [webHttp behavior](https://docs.microsoft.com/en-us/dotnet/framework/configure-apps/file-schema/wcf/webhttp), and [WebInvokeAttribute](https://docs.microsoft.com/en-us/dotnet/api/system.servicemodel.web.webinvokeattribute) class.

## Self-hosted WCF service

The code example follows. Note that we have removed the [WebGetAttribute](https://docs.microsoft.com/en-us/dotnet/api/system.servicemodel.web.webgetattribute) class from the methods in the service contract interface, and added WebInvoke attribute to the methods in the service implementation.

<!-- highlight 24,25,26,32,33,34 -->

```c#
using System;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace wcf
{
    [ServiceContract]
    interface IMyService
    {
        [OperationContract]
        void SetSomething(string something);

        [OperationContract]
        string GetSomething();
    }

    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
    class MyService : IMyService
    {
        string _something = String.Empty;

        #region IMyService Members

        [WebInvoke(Method = "GET",
                   ResponseFormat = WebMessageFormat.Json,
                   UriTemplate = "SetSomething?something={something}")]
        public void SetSomething(string something)
        {
            _something = something;
        }

        [WebInvoke(Method = "GET",
                   ResponseFormat = WebMessageFormat.Json,
                   UriTemplate = "GetSomething")]
        public string GetSomething()
        {
            return _something;
        }

        #endregion
    }

    class Program
    {
        static void Main(string[] args)
        {
            using (ServiceHost host = new ServiceHost(typeof(wcf.MyService)))
            {
                host.Open(); // end point specified in app config

                Console.WriteLine("Hit Enter to quit.");
                Console.ReadLine();
            }
        }
    }
}
```

## app.config

The modified `app.config` follows. Note that the behavior is now `webHttp` instead of `enableWebScript`.

```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.serviceModel>
    <behaviors>
      <endpointBehaviors>
        <behavior name="webHttp">
          <webHttp />
        </behavior>
      </endpointBehaviors>
    </behaviors>
    <services>
      <service name="wcf.MyService">
        <endpoint address="http://localhost:8003/myservice"
          binding="webHttpBinding"
          contract="wcf.IMyService"
          behaviorConfiguration="webHttp"/>
      </service>
    </services>
  </system.serviceModel>
</configuration>
```

## jQuery test app

The code follows. Only difference being, we don't access the d property to read value returned by the service. We can send parameters in the URI instead of query string, now that we use `UriTemplate`.

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test</title>
    <script type="text/javascript"
      src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.10.1.min.js">
    </script>
    <script type="text/javascript">
        var url = 'http://localhost:8003/myservice/';
        $(document).ready(function () {
            $("#set").click(function () {
                var urlSet = url + 'SetSomething?something='
                    + $("#text").val();
                $.getJSON(urlSet, function (data) {
                    // nothing to do
                });
            });

            $("#get").click(function () {
                var urlGet = url + 'GetSomething';
                $.getJSON(urlGet, function (data) {
                    $('#text').val(data);
                });
            });
        });
    </script>
  </head>
  <body>
    <p>Test MyService</p>
    <form action="">
      <input id="text" type="text" value="Hello" />
      <input id="set" type="button" value="Set"/>
      <input id="get" type="button" value="Get" />
    </form>
  </body>
</html>
```

## Support cross-origin requests

Cross-origin (CORS) requests are easily supported by adding a custom behavior as documented [here](http://enable-cors.org/server_wcf.html).
