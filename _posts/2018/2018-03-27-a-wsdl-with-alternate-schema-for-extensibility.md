---
layout: default
title: A WSDL with alternate schema for extensibility
tags: soap wsdl schema xml
comments: true
---
# A WSDL with alternate schema for extensibility

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

The standalone WSDL file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<wsdl:definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:echo="http://echo" xmlns:alt="http://alternate" targetNamespace="http://echo">
  <!--========================================================-->
  <!--                     T Y P E S                          -->
  <!--========================================================-->
  <wsdl:types>
    <schema targetNamespace="http://alternate" elementFormDefault="qualified" xmlns="http://www.w3.org/2001/XMLSchema">
    <complexType name="Content">
        <sequence>
        <element name="message" type="string" />
        </sequence>
    </complexType>
    </schema>
    <schema targetNamespace="http://echo" elementFormDefault="qualified" xmlns="http://www.w3.org/2001/XMLSchema">
      <element name="SessionId" type="string" />
      <element name="Echo" type="alt:Content" />
    </schema>
  </wsdl:types>
  <!--========================================================-->
  <!--                    M E S S A G E S                     -->
  <!--========================================================-->
  <wsdl:message name="EchoRequestMessage">
    <wsdl:part name="header" element="echo:SessionId" />
    <wsdl:part name="requestBody" element="echo:Echo" />
  </wsdl:message>
   <wsdl:message name="EchoResponseMessage">
    <wsdl:part name="header" element="echo:SessionId" />
    <wsdl:part name="responseBody" element="echo:Echo" />
  </wsdl:message>
  <!--========================================================-->
  <!--                    P O R T  T Y P E                    -->
  <!--========================================================-->
  <wsdl:portType name="EchoServiceEndpoint">
    <wsdl:operation name="Echo">
      <wsdl:input message="echo:EchoRequestMessage" />
      <wsdl:output message="echo:EchoResponseMessage" />
    </wsdl:operation>
  </wsdl:portType>
  <!--========================================================-->
  <!--                     B I N D I N G                      -->
  <!--========================================================-->
  <wsdl:binding name="EchoServiceSoapBinding" type="echo:EchoServiceEndpoint">
    <soap:binding transport="http://schemas.xmlsoap.org/soap/http" />
    <wsdl:operation name="Echo">
      <soap:operation soapAction="echo" style="document" />
      <wsdl:input>
        <soap:header message="echo:EchoRequestMessage" part="header" use="literal" />
        <soap:body parts="requestBody" use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:header message="echo:EchoResponseMessage" part="header" use="literal" />
        <soap:body parts="responseBody" use="literal" />
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>
  <!--========================================================-->
  <!--                     S E R V I C E                      -->
  <!--========================================================-->
  <wsdl:service name="EchoService">
    <wsdl:port name="port" binding="echo:EchoServiceSoapBinding">
      <soap:address location="http://localhost:8001/echo" />
    </wsdl:port>
  </wsdl:service>
</wsdl:definitions>
```

The alternate schema can be in a separate file, as shown in listing `alternate.xsd`. A WSDL file that uses the schema file is shown in listing `example.wsdl`. Note the use of `import` element from `wsdl` namespace.

## alternate.xsd

```xml
<?xml version="1.0" encoding="utf-8"?>
<schema targetNamespace="http://alternate" xmlns="http://www.w3.org/2001/XMLSchema" xmlns:alt="http://alternate" elementFormDefault="qualified" attributeFormDefault="unqualified" version="1.0">
  <complexType name="Content">
    <sequence>
      <element name="message" type="string" />
    </sequence>
  </complexType>
</schema>
```

## example.wsdl

```xml
<?xml version="1.0" encoding="UTF-8"?>
<wsdl:definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:echo="http://echo" xmlns:alt="http://alternate" targetNamespace="http://echo">
  <!--========================================================-->
  <!--                     T Y P E S                          -->
  <!--========================================================-->
  <wsdl:import location="alternate.xsd" namespace="http://alternate"/>
  <wsdl:types>
    <schema targetNamespace="http://echo" elementFormDefault="qualified" xmlns="http://www.w3.org/2001/XMLSchema">
      <element name="SessionId" type="string" />
      <element name="Echo" type="alt:Content" />
    </schema>
  </wsdl:types>
  <!--========================================================-->
  <!--                    M E S S A G E S                     -->
  <!--========================================================-->
  <wsdl:message name="EchoRequestMessage">
    <wsdl:part name="header" element="echo:SessionId" />
    <wsdl:part name="requestBody" element="echo:Echo" />
  </wsdl:message>

   <wsdl:message name="EchoResponseMessage">
    <wsdl:part name="header" element="echo:SessionId" />
    <wsdl:part name="responseBody" element="echo:Echo" />
  </wsdl:message>
  <!--========================================================-->
  <!--                    P O R T  T Y P E                    -->
  <!--========================================================-->
  <wsdl:portType name="EchoServiceEndpoint">
    <wsdl:operation name="Echo">
      <wsdl:input message="echo:EchoRequestMessage" />
      <wsdl:output message="echo:EchoResponseMessage" />
    </wsdl:operation>
  </wsdl:portType>
  <!--========================================================-->
  <!--                     B I N D I N G                      -->
  <!--========================================================-->
  <wsdl:binding name="EchoServiceSoapBinding" type="echo:EchoServiceEndpoint">
    <soap:binding transport="http://schemas.xmlsoap.org/soap/http" />
    <wsdl:operation name="Echo">
      <soap:operation soapAction="echo" style="document" />
      <wsdl:input>
        <soap:header message="echo:EchoRequestMessage" part="header" use="literal" />
        <soap:body parts="requestBody" use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:header message="echo:EchoResponseMessage" part="header" use="literal" />
        <soap:body parts="responseBody" use="literal" />
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>
  <!--========================================================-->
  <!--                     S E R V I C E                      -->
  <!--========================================================-->
  <wsdl:service name="EchoService">
    <wsdl:port name="port" binding="echo:EchoServiceSoapBinding">
      <soap:address location="http://localhost:8001/echo" />
    </wsdl:port>
  </wsdl:service>
</wsdl:definitions>
```
