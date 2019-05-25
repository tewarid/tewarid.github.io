---
layout: default
title: A simple TCP proxy in Node.js
tags: tcp proxy node nodejs
comments: true
---
# A simple TCP proxy in Node.js

A TCP proxy built with Node.js, that may be used to access a service on another network, is available at [GitHub](https://github.com/tewarid/node-tcp-proxy).

It is an extensible replacement for socat when used thus

```bash
socat TCP-LISTEN:port1,fork TCP:host:port2
```

To achieve the same with node-tcp-proxy

```bash
tcpproxy  --proxyPort [port1] --serviceHost [host] --servicePort [port2]
```

To install node-tcp-proxy using npm

```bash
sudo npm install -g node-tcp-proxy
```

To create a proxy in your own code

```javascript
var proxy = require("node-tcp-proxy");
var newProxy = proxy.createProxy(8080, "hostname", 10080);
```

To end the proxy

```javascript
newProxy.end();
```
