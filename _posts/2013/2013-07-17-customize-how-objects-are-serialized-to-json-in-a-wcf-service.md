---
layout: default
title: Customize how objects are serialized to JSON in a WCF service
tags: json wcf c# html javascript .net
comments: true
---
# Customize how objects are serialized to JSON in a WCF service

This post presents an improved version of the service presented in [Cleaner JSON from a WCF service with webHttp behavior]({% link _posts/2013/2013-06-26-cleaner-json-from-a-wcf-service-with-webhttp-behavior.md %}). I demonstrate how to customize serialization of an object to JSON.

## Custom object

I define a new `Person` class, annotated using the `DataContract` attribute. The `DataMember` attribute applied to each attribute of the class allows us to specify an alternative name for the attribute, whether it is required to be present, the order in which it is serialized, and so on.

```c#
using System.Runtime.Serialization;

namespace RestService
{
    [DataContract()]
    public class Person : IExtensibleDataObject
    {
        [DataMember(Name = "id", IsRequired = false)]
        public string ID { get; set; }

        [DataMember(Name = "name", IsRequired = true)]
        public string Name { get; set; }

        [DataMember(Name = "numbers", IsRequired = false)]
        public string[] PhoneNumbers { get; set; }

        public ExtensionDataObject ExtensionData { get; set; }
    }
}
```

## Service interface

The `IRestService` interface is modified to add additional method signatures that consume and return `Person` objects.

```c#
using System.ServiceModel;

namespace RestService
{
    [ServiceContract]
    interface IRestService
    {
        [OperationContract]
        void Options();

        [OperationContract]
        string Person(Person p);

        [OperationContract]
        Person GetPerson(string id);
    }

}
```

## Service implementation

The service method `Person` receives an instance of `Person` using HTTP POST to URI `/Person`. WCF handles conversion of JSON to the `Person` object, and vice-versa. The service method `GetPerson` handles requests to retrieve details of a `Person` using an ID.

```c#
using System.Collections.Concurrent;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Threading;

namespace RestService
{
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
    public class RestServiceImplementation : IRestService
    {
        static private int nextID = 1;
        static ConcurrentDictionary<string, Person> people = new ConcurrentDictionary<string, Person>();

        #region IMyService Members

        [WebInvoke(Method = "OPTIONS",
            UriTemplate = "/*")]
        public void Options()
        {

        }

        [WebInvoke(Method = "POST",
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "/Person")]
        public string Person(Person p)
        {
            if(p.ID == null)
            {
                p.ID = nextID.ToString();
                Interlocked.Increment(ref nextID);
            }
            people[p.ID] = p;
            return p.ID;
        }

        [WebInvoke(Method = "GET",
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "/Person/{id}")]
        public Person GetPerson(string id)
        {
            Person p;
            p = people.TryGetValue(id, out p) ? p : null;
            return p;
        }
        #endregion
    }
}
```

## App.config

The `app.config` doesn't need to be changed. It states for instance that our service endpoint is http://localhost:8002/restservice. Note the use of custom behavior `webHttpCORS`, that allows the service to accessed from other domains.

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.serviceModel>
    <bindings>
      <webHttpBinding>
        <binding name="webHttpBinding"/>
      </webHttpBinding>
    </bindings>
    <extensions>
      <behaviorExtensions>
        <add name="crossOriginResourceSharingBehavior" type="RestService.EnableCrossOriginResourceSharingBehavior, RestService"/>
      </behaviorExtensions>
    </extensions>
    <behaviors>
      <endpointBehaviors>
        <behavior name="webHttpCORS">
          <webHttp/>
          <crossOriginResourceSharingBehavior/>
        </behavior>
      </endpointBehaviors>
    </behaviors>
    <services>
      <service name="RestService.RestServiceImplementation">
        <endpoint address="http://localhost:8002/restservice" binding="webHttpBinding" bindingConfiguration="webHttpBinding" contract="RestService.IRestService" behaviorConfiguration="webHttpCORS"/>
      </service>
    </services>
  </system.serviceModel>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.5"/>
  </startup>
</configuration>
```

## Hosting the service

The service can be hosted in a console app as follows

```c#
using System;
using System.ServiceModel;

namespace WebHttp
{
    class Program
    {
        static void Main(string[] args)
        {
            ServiceHost host = new ServiceHost(typeof(WebHttp.JsonService.MyServiceImplementation));
            host.Open();

            Console.WriteLine("Hit Enter to quit.");
            Console.ReadLine();
        }
    }
}
```

## Testing with Fiddler

[Fiddler](http://www.telerik.com/fiddler) is a powerful Web debugger written in .NET. It can be used to send HTTP requests and observe HTTP responses. The following figure shows the raw request and response when creating a new Person called John. It is important to set the Content-Type header to `application/json`. Try and send the JSON shown in the request pane using the Composer tab. The service responds with the identifier of the Person added or updated.

![Fiddler Post Request](/assets/img/windows-fiddler-post.png)

The following figure shows a query to read Person with id 1\. Try the GET request by using the Composer tab.

![Fiddler Get Request](/assets/img/windows-fiddler-get.png)

## Using jQuery to access the service

Here's a simple web page that uses jQuery to interact with the service

```html
<!DOCTYPE html>
<html>
<head>
    <title>www</title>
    <script type="text/javascript"
        src="https://code.jquery.com/jquery-2.1.4.min.js">
    </script>
    <script type="text/javascript"
        src="js/jqueryHelper.js">
    </script>
</head>
<body>
    <form action="">
        <input id="name" type="text" value="" />
        <input id="add" type="button" value="Add" />
    </form>
        List of people you've added:
<ul id="people"></ul>
<img src="image/HTML5_Logo_64.png" />

    <script type="text/javascript">
        var url = 'http://localhost:8002/restservice/'; // base url

        $(document).ready(documentReady);

        function documentReady() {
            $("#add").click(addClick);
        }

        function addClick() {
            var person = new Object();
            person.name = $('#name').val();
            var json = JSON.stringify(person);
            var urlAdd = url + 'Person';
            $.ajax({
                url: urlAdd,
                method: "POST",
                dataType: "json",
                data: json,
                contentType: "application/json; charset=utf-8",
            }).done(function (data) {
                person.id = parseInt(data);
                $('
    <li></li>
')
                    .text(person.id + ':' + person.name)
                    .appendTo('#people');
            });
        }
    </script>
</body>
</html>
```

## Further Reading

I refer you to [Stand-Alone JSON Serialization](https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/stand-alone-json-serialization) for reading further about how JSON serialization works for complex types, but I strongly suggest keeping things simple for maximum portability.
