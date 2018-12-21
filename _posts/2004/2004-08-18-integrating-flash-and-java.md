---
layout: default
title: Integrating Flash and Java
tags: adobe flash java web service apache axis soap
comments: true
---
# Integrating Flash and Java

This is a short tutorial on integrating Flash and Java using Web Services and Flash Remoting. We start by constructing a short example for each approach and then point out the advantages and limitations of the approach. We will not be entering into much detail on how to configure the tools used in this tutorial - leaving that as an exercise for the reader. We do however link to sites where you can download these tools and seek help on configuring them.

## Publish a Java web service using Apache Axis

Let us begin by publishing a simple web service using [Apache Axis](https://axis.apache.org/axis/). The example we will use in this section is a simple use case for creating a new customer with a name and address information. We will represent the customer using a Customer class shown below. The class follows the JavaBeans syntax for specifying getters and setters to expose private attributes. Only those attributes that have getters and setters will be serialized or de-serialized by Axis. The class would also need a default no arguments constructor if it had a constructor with arguments.

```java
package flashjava;

public class Customer {
    private int id;
    private String firstName;
    private String lastName;
    private String street;
    private String city;
    private String state;
    private String country;
    private String zip;
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }
    public String getCountry() {
        return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }
    public String getStreet() {
        return street;
    }
    public void setStreet(String street) {
        this.street = street;
    }
    public String getZip() {
        return zip;
    }
    public void setZip(String zip) {
        this.zip = zip;
    }
}
```

Next, let us construct a class called `ServiceFacade` that contains a method called `createCustomer` which receives a `Customer` instance. To keep our example simple we just echo back the `Customer` instance to the caller.

```java
package flashjava;

public class ServiceFacade {
    private static int seq = 0; 
    public Customer createCustomer(Customer customer) {
        customer.setId(++seq);
        return customer;
    }
}
```

Next, we will expose the `ServiceFacade` class to Flash using Apache Axis. We assume you have a J2EE web module with Apache Axis configured in [Apache Tomcat](https://tomcat.apache.org/). We will use a `wsdd` file \- as shown below \- to publish our simple web service using Axis. The service element in the `wsdd` file tells Axis that we are publishing a new web service called `flashjava`, the class providing the service is `ServiceFacade` and that all methods in the class should be exposed. The `beanMapping` element within the service element tells Axis that we want to publish a new custom type called `Customer` and the Java class it maps to is `flashjava.Customer`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<deployment 
    xmlns="http://xml.apache.org/axis/wsdd/" 
    xmlns:java="http://xml.apache.org/axis/wsdd/providers/java">
    <globalConfiguration>
        <parameter name="adminPassword" value="admin"/>
        <parameter name="attachments.Directory" value="C:\eclipse\workspace\flashjava\WebContent\WEB-INF\attachments"/>
        <parameter name="attachments.implementation" value="org.apache.axis.attachments.AttachmentsImpl"/>
        <parameter name="sendXsiTypes" value="true"/>
        <parameter name="sendMultiRefs" value="true"/>
        <parameter name="sendXMLDeclaration" value="true"/>
        <parameter name="axis.sendMinimizedElements" value="true"/>
        <requestFlow>
            <handler type="java:org.apache.axis.handlers.JWSHandler">
                <parameter name="scope" value="session"/>
            </handler>
            <handler type="java:org.apache.axis.handlers.JWSHandler">
                <parameter name="scope" value="request"/>
                <parameter name="extension" value=".jwr"/>
            </handler>
        </requestFlow>
    </globalConfiguration>
    <handler name="LocalResponder" type="java:org.apache.axis.transport.local.LocalResponder"/>
    <handler name="URLMapper" type="java:org.apache.axis.handlers.http.URLMapper"/>
    <handler name="Authenticate" type="java:org.apache.axis.handlers.SimpleAuthenticationHandler"/>
    <service name="flashjava" provider="java:RPC">
        <parameter name="allowedRoles" value="*"/>
        <parameter name="allowedMethods" value="*"/>
        <parameter name="className" value="flashjava.ServiceFacade"/>
        <beanMapping languageSpecificType="java:flashjava.Customer" qname="ns1:Customer" 
            xmlns:ns1="urn:BeanService"/>
    </service>
    <service name="AdminService" provider="java:MSG">
        <parameter name="allowedMethods" value="AdminService"/>
        <parameter name="enableRemoteAdmin" value="false"/>
        <parameter name="className" value="org.apache.axis.utils.Admin"/>
        <namespace>http://xml.apache.org/axis/wsdd/</namespace>
    </service>
    <service name="Version" provider="java:RPC">
        <parameter name="allowedMethods" value="getVersion"/>
        <parameter name="className" value="org.apache.axis.Version"/>
    </service>
    <transport name="http">
        <requestFlow>
            <handler type="URLMapper"/>
            <handler type="java:org.apache.axis.handlers.http.HTTPAuthHandler"/>
        </requestFlow>
    </transport>
    <transport name="local">
        <responseFlow>
            <handler type="LocalResponder"/>
        </responseFlow>
    </transport>
</deployment>
```

To publish the web service using AdminClient, we issue the following command:

```cmd
java org.apache.axis.client.AdminClient -sflashjava/services/AdminService -p 8080 publish.wsdd
```

You can also use the publish target of the Ant script build.xml, provided with the source code of this tutorial, to publish the web service. Access the URL <http://localhost/flashjava/services/> to verify that the flashjava web service is listed by Axis. We have used a web application context called flashjava in the call to AdminClient and in the URL.

## Consume the web service in Flash

We will now create a Flash client to consume the web service we published in the previous section. We will use Flash MX Professional 2004 to create a simple user interface to input information about a customer, as shown below.

![Flash user interface to consume the Java web service](/assets/img/flash-form.png)

The OK button event handler code that invokes the web service is shown below. To be able to compile the SWF the Flash document must have the WebServiceConnector in the library. Just drop a WebServiceConnector component onto a frame and delete it and Flash will add the component to the document library.

```javascript
on (click) {
    import mx.services.*;
    var customer:Customer = new Customer();
    customer.id = 0;
    customer.firstName = _root.txtFirstName.text;
    customer.lastName = _root.txtLastName.text;
    customer.street = _root.txtStreet.text;
    customer.city = _root.txtCity.text;
    customer.state = _root.txtState.text;
    customer.country = _root.txtCountry.text;
    executeCreateCustomer(customer);

    function executeCreateCustomer(customer:Customer) {
        var ws:WebService = new WebService
            ("http://localhost:8080/flashjava/services/flashjava?wsdl");
        ws.onFault = function(fault) {
            trace("onFault")
        };
        ws.onLoad = function(wsdl) {
            trace ("onLoad");
        };
        var pendingResult = ws.createCustomer(customer);
        pendingResult.onResult = function(obj) {
            trace("onResult");
            trace(obj.id);
            _root.txtID.text = obj.id;
        }
    }
}
```

To test the Flash interface, just enter any values in the form fields and hit OK. If the service call goes through, the application will update the ID field with a positive integer value.

## Advantages and Limitations of SOAP

- Performance

    Web service based access is very slow due to XML parsing and validation overhead. Since Java to Java web service access is many times faster this probably means that Macromedia has a bad implementation of SOAP web services in the Flash player. The Flash player also exhibits memory leaks.

- Object model

    The object model may need to be tweaked when using web services. A web service call fails when passing objects with circular references, for example, a parent referencing a child object which in turn references the parent. For a new application this can be taken into account when designing new objects but for legacy applications it may not be possible to modify the object model. A web service call also fails when you try to send a complex object \- containing an array of objects \- as a parameter. To work around this limitation you may opt to serialize a complex object as an xml string, send that across to the server and use a framework like [Castor](http://castor.exolab.org/xml-framework.html) to de-serialize the objects.

- Reuse of existing Web Services

    Despite the problems cited so far, one big advantage of using SOAP based web services is the universality of these services. If you are simply reusing the any number of existing SOAP based web services, you may have no other option than to use the SOAP based web service support in Flash.

Flash Remoting \- discussed in the following section \- overcomes most of the limitations of the SOAP implementation in Flash.

## Publish a Java class using OpenAMF

[OpenAMF](https://sourceforge.net/projects/openamf/) is an open source Flash remoting framework that can be used to expose Java classes to Flash using Flash remoting. Flash remoting uses a native format for serializing and de-serializing Flash objects which results in much better performance as compared to calling SOAP based web services.

Next, we will publish the `ServiceFacade` class using OpenAMF. To configure OpenAMF copy the libraries \- jar files \- from the OpenAMF distribution to the `lib` folder of your web module. Then, create an xml file called `openamf-config.xml` with the configuration shown below and place it in the `WEB-INF` folder of your web module.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<config>
    <invoker>
        <name>Java</name>
        <class>org.openamf.invoker.JavaServiceInvoker</class>
    </invoker>

    <!-- Custom object mapping -->
    <custom-class-mapping>
        <java-class>flashjava.Customer</java-class>
        <custom-class>Customer</custom-class>
    </custom-class-mapping>

    <!-- Required  for AdvancedGateway -->
    <service>
        <name>flashjava</name>
        <service-location>flashjava.ServiceFacade</service-location>
        <invoker-ref>Java</invoker-ref>
        <method>
            <name>createCustomer</name>
            <parameter>
                <type>*</type>
            </parameter>
        </method>
    </service>
</config>
```

The web module configuration file \- `web.xml` \- also needs to be modified to publish the OpenAMF flash remoting gateway. The configuration required is shown below.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app id="WebApp_ID" version="2.4" xmlns="http://java.sun.com/xml/ns/j2ee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">
    <display-name>flashjava</display-name>

    <!-- Axis -->
    <servlet>
        <display-name>Apache-Axis Servlet</display-name>
        <servlet-name>AxisServlet</servlet-name>
        <servlet-class>
            org.apache.axis.transport.http.AxisServlet
        </servlet-class>
    </servlet>

    <servlet>
        <display-name>Axis Admin Servlet</display-name>
        <servlet-name>AdminServlet</servlet-name>
        <servlet-class>
            org.apache.axis.transport.http.AdminServlet
        </servlet-class>
        <load-on-startup>100</load-on-startup>
    </servlet>

    <!-- Flash Remoting Gateway -->
    <servlet>
        <description>AdvancedGateway</description>
        <display-name>AdvancedGateway</display-name>
        <servlet-name>AdvancedGateway</servlet-name>
        <servlet-class>org.openamf.AdvancedGateway</servlet-class>
        <init-param>
            <description>Location of the OpenAMF config file.</description>
            <param-name>OPENAMF_CONFIG</param-name>
            <param-value>/WEB-INF/openamf-config.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <!-- Axis -->
    <servlet-mapping>
        <servlet-name>AxisServlet</servlet-name>
        <url-pattern>/servlet/AxisServlet</url-pattern>
    </servlet-mapping>

    <servlet-mapping>
        <servlet-name>AxisServlet</servlet-name>
        <url-pattern>/services/*</url-pattern>
    </servlet-mapping>

    <!-- Flash Remoting Gateway -->
    <servlet-mapping>
        <servlet-name>AdvancedGateway</servlet-name>
        <url-pattern>/gateway</url-pattern>
    </servlet-mapping>

    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>index.htm</welcome-file>
        <welcome-file>index.jsp</welcome-file>
        <welcome-file>default.html</welcome-file>
        <welcome-file>default.htm</welcome-file>
        <welcome-file>default.jsp</welcome-file>
    </welcome-file-list>
</web-app>
```

This wraps up the configuration of the flash remoting gateway.

## Use Flash Remoting to interact with the Java class

Let us now create a Flash client to interact with the remoting gateway we set up in the previous section. The Flash client is similar to the example used in the section on web services, the only difference being the code in the OK button event handler. The event handler code shown below uses Flash remoting to call the ServiceFacade class instead of the SOAP web service. You may need to install ActionScript APIs to invoke Flash remoting services.

```javascript
on (click) {
    #include "NetServices.as"
     // Flash Remoting object mapping
    Object.registerClass( "Customer" , Customer );
    // Call the service
    var customer:Customer = new Customer();
    customer.id = 0;
    customer.firstName = _root.txtFirstName.text;
    customer.lastName = _root.txtLastName.text;
    customer.street = _root.txtStreet.text;
    customer.city = _root.txtCity.text;
    customer.state = _root.txtState.text;
    customer.country = _root.txtCountry.text;
    executeCreateCustomer(customer, this);
    createCustomer_Result = function (obj) {
        trace("Result");
        _root.txtID.text = obj.id;
    }
    createCustomer_Status = function (obj) {
        trace("Status");
    }

    function executeCreateCustomer(customer:Customer, caller) {
        NetServices.setDefaultGatewayUrl
            ("http://localhost:8080/flashjava/gateway");
        var gatewayConnection = NetServices.createGatewayConnection();
        var service = gatewayConnection.getService("flashjava", caller);
        service.createCustomer(customer);
    }
}
```

The following points should help you overcome any potential problems when using OpenAMF:

- A Java object serialized by OpenAMF must:

    - Specify getters and setters.

- A Java object de-serialized by OpenAMF must:

    - Have a default (no argument) constructor.

    - Specify getters and setters.

    - Must have a custom-class-mapping in openamf-config.xml.

- A Flash ActionScript object must:

    - Have a default no arguments constructor and the constructor must not assign values to fields received through Flash remoting as these values will be overwritten.

    - Have attributes whose name and case match the name and case of the attributes in the corresponding remote object.

    - Be registered using the Object.registerClass method which associates an ActionScript class to the type of an incoming remote object.

## Advantages and Limitations of Flash Remoting

- Performance

    Flash remoting calls perform much better than Flash SOAP based web service calls. The use of Flash remoting is highly recommended for transferring large amounts of data.

- Object Model

    Flash Remoting handles complex objects and object hierarchies with circular references very well.

The only disadvantage of Flash remoting is that it is not a universal standard like SOAP. This limits its use when consuming existing SOAP based web services, unless you consume the web service on the server and expose it as a flash remoting service.
