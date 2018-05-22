---
layout: default
title: A WSDL with alternate schema for extensibility
tags: soap wsdl schema xml
comments: true
---

This post presents a [SOAP](https://www.w3.org/TR/2000/NOTE-SOAP-20000508/) [WSDL](https://www.w3.org/TR/2001/NOTE-wsdl-20010315) in the [document/literal style](https://www.ibm.com/developerworks/webservices/library/ws-whichwsdl/), using qualified elements from an alternate schema to support [extensibility](https://www.w3.org/2005/07/xml-schema-patterns.html).

The SOAP request described by the WSDL looks like

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:echo="http://echo" xmlns:alt="http://alternate">
   <soapenv:Header>
      <echo:SessionId>?</echo:SessionId>
   </soapenv:Header>
   <soapenv:Body>
      <echo:Echo>
         <alt:message>?</alt:message>
      </echo:Echo>
   </soapenv:Body>
</soapenv:Envelope>
```

The SOAP response looks like

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:echo="http://echo" xmlns:alt="http://alternate">
   <soapenv:Header>
      <echo:SessionId>?</echo:SessionId>
   </soapenv:Header>
   <soapenv:Body>
      <echo:EchoResponse>
         <alt:message>?</alt:message>
      </echo:EchoResponse>
   </soapenv:Body>
</soapenv:Envelope>
```

The standalone WSDL file is shown in listing `example-standalone.wsdl`.

{% gist 9eb5a30e37cc8f3d6ff35333229b927e %}

The alternate schema can be in a separate file, as shown in listing `alternate.xsd`. A WSDL file that uses the schema file is shown in listing `example.wsdl`. Note the use of `import` element from `wsdl` namespace.

{% gist 319bfa08fd6b3072d19ddd2d421cdfe6 %}
