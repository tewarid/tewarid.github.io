---
layout: default
title: Web chat using Strophe and Apache Vysper
tags: apache vysper strophejs xmpp
---

I was told about Apache Vysper by a colleague at work and thought I'd give it a try. It is very much in development, lacks documentation, and clustering support for those looking to scale.

I'll replace Openfire in the web chat setup I did in [Web chat using Strophe and Openfire]({% link _posts/2011/2011-03-31-web-chat-using-strophe-and-openfire.md %}). You'll need a more feature-rich client than trophyim to be able to add users to the roster and such. I used [Jitsi](http://www.jitsi.org/).


### Setup Vysper

Grab a copy of Vysper [version 0.7](http://mina.apache.org/vysper-project/download_0.7.html). Extract it to any folder. You'll need a JVM to run the server. Let us configure a few things by editing file `spring-config.xml` located in the config folder.

Locate the following lines and change the domain name - your machine name should do fine or localhost

```xml
<!-- TODO change domain name to your domain -->
<constructor-arg value="localhost"/>
```

Locate the following lines and change the admin user domain and password. Add more users if you wish.

```xml
<bean id="addUsers" class="org.apache.vysper.spring.AddUserHelper">
    <constructor-arg index="0">
        <map>
            <entry key="admin@localhost" value="passw0rd" />
            <entry key="friend@localhost" value="passw0rd" />
```

Uncomment the following line - thus enabling BOSH

```xml
<ref bean="boshEndpoint"/>
```

Uncomment the BOSH endpoint configuration

```xml
<bean id="boshEndpoint" class="org.apache.vysper.xmpp.extension.xep0124.BoshEndpoint">
    <property name="accessControlAllowOrigin">
        <list><value>*</value></list>
    </property>
    <property name="port" value="8080" />
    <property name="contextPath" value="/bosh" />
</bean>
```

### Start Vysper

Head to the command line and execute `run.bat` or `run.sh` from the bin folder. If all goes well, you should be able to access http://localhost:8080/bosh/ from the browser.

### Execute trophyim

You’ll need to change the variable `TROPHYIM_BOSH_SERVICE` in `trophyim.js` file. Assign it the value `http://localhost:8080/bosh/`. Launch trophyim by opening `index.html` in the browser using the `file://` url scheme. You can use a client like Jitsi to setup contacts, and try chatting with them using trophyim.

We do not require an HTTP server and proxy. I suspect Vysper supports CORS out of the box. That is good news indeed.
