---
layout: default
title: Consuming WCF services using JQuery JSON
tags:
comments: true
---

In this post we'll use the WebHttpBinding for communication between a browser application and a service.

### Test App

We'll use the following assemblies and the corresponding namespaces from the .NET Framework version 3.5.

```c#
System.ServiceModel
System.ServiceModel.Web
```

The console application listed below hosts and exposes a test service. All the service methods are annotated using the WebGetAttribute class, which means they will be accessed using the HTTP GET method. [Other](http://msdn.microsoft.com/en-us/library/bb472541.aspx "Advanced Web Programming") HTTP methods such as POST, PUT or DELETE can be specified using the WebInvokeAttribute class.

```c#
[ServiceContract]
interface IMyService
{
    [OperationContract]
    [WebGet]
    void SetSomething(string something);

    [OperationContract]
    [WebGet]
    string GetSomething();
}

[ServiceBehavior(InstanceContextMode = InstanceContextMode.Single)]
class MyService : IMyService
{
    string _something = String.Empty;

    #region IMyService Members

    public void SetSomething(string something)
    {
        _something = something;
    }

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
```

### App.Config

We specify the service endpoint and behavior configuration in the application configuration file, it can also be done in code. If you intend to run your service under IIS, you can copy the system.serviceModel element to your Web.config.

```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.serviceModel>
    <bindings>
      <webHttpBinding>
        <binding name="webBinding"/>
      </webHttpBinding>
    </bindings>
    <behaviors>
      <endpointBehaviors>
        <behavior name="jsonBehavior">
          <enableWebScript/>
        </behavior>
      </endpointBehaviors>
    </behaviors>
    <services>
      <service name="wcf.MyService">
        <endpoint address="http://localhost:8003/myservice"
          binding="webHttpBinding"
          bindingConfiguration="webBinding"
          contract="wcf.IMyService"
          behaviorConfiguration="jsonBehavior"/>
      </service>
    </services>
  </system.serviceModel>
</configuration>
```

### Netsh

You must allow a user without admin privileges to register a URL. If you don't do this, you'll get the following exception when you run the app:

```text
Unhandled Exception: System.ServiceModel.AddressAccessDeniedException: HTTP could
not register URL http://+:8003/myservice/. Your process does not have access rights to this
namespace (see http://go.microsoft.com/fwlink/?LinkId=70353 for details).
---> System.Net.HttpListenerException: Access is denied
```

Run the netsh command as follows to grant your user permission to access the URL:

```cmd
netsh http add urlacl url=http://+:8003/myservice user=DOMAIN\user
```

### Test the service

Launch a browser and go to `http://localhost:8003/myservice/SetSomething?something=hello%20world`. It calls the `SetSomething` method.

Then, go to `http://localhost:8003/myservice/GetSomething`. It retrieves the value set using the previous call.

The following text should appear in the browser window

```text
hello world
```

### JQuery JSON app

The following application built using JQuery repeats the previous test. Most modern browsers will not allow cross-origin requests unless authorized by the server. It is fairly easy to [enable](http://joshuamcginnis.com/2011/02/28/how-to-disable-same-origin-policy-in-chrome/) cross-origin requests in Chrome.

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title></title>
    <script type="text/javascript"
      src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.10.1.min.js">
    </script>
    <script type="text/javascript">
      var url = 'http://localhost:8003/myservice/';
      $(document).ready(function() {
        $("#set").click(function() {
          var urlSet = url + 'SetSomething?something='
              + $("#text").val();
          $.getJSON(urlSet, function(data) {
              // nothing to do
          });
        });

        $("#get").click(function() {
          var urlGet = url + 'GetSomething';
          $.getJSON(urlGet, function(data) {
              $('#text').val(data.d);
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

That's all for now.
