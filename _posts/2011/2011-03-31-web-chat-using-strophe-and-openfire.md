---
layout: default
title: Web chat using Strophe and Openfire
tags: openfire xmpp bosh javascript strophejs
comments: true
---

[XMPP](http://xmpp.org/about-xmpp/) is now widely used to implement messaging and presence services. Popular applications and services such as Jabber, Google Voice, and Google Talk are based on it. [Openfire](http://xmpp.org/about-xmpp/) is one really popular cross-platform Java server infrastructure for XMPP. On the client side there is an increasing trend towards applications done in HTML and JavaScript. There now exist some pure JavaScript client libraries such as [Strophe](https://github.com/metajack/strophejs) that support this trend. These work with the [BOSH](http://xmpp.org/extensions/xep-0124.html) HTTP binding provided by Openfire.

In this post, I explain how I setup a simple chat application called [trophyim](http://code.google.com/p/trophyim/) to run with Openfire. I'll use Apache httpd along the way to get around cross-origin errors, by using it as a proxy to access the http binding service provided by Openfire. Openfire should soon [implement](https://issues.igniterealtime.org/browse/OF-342) [CORS](https://www.w3.org/TR/cors/#use-cases) support so we won't need to proxy HTTP requests in the future.

### Obtain and build Strophe

Download Strophe from [GitHub](https://github.com/metajack/strophejs/). Build it using `make`. I usually have a Linux VM around for such occasions.

### Setup Openfire and Apache httpd

Download and setup Openfire - at version 3.7.0 at the time of writing, and Apache httpd. Openfire provides a web browser based administration console at `http://localhost:9090` that you can use to add users. The BOSH based http binding service runs at port 7070. A Strophe connection needs to be opened to URL `http://localhost:7070/http-bind/`.

### Setup trophyim

Obtain trophyim - version 0.3 used here, provide access to it through Apache httpd so that accessing `http://localhost/trophyim.0.3/index.html` from the browser runs the chat client. Copy `strophe.js` to a folder called `strophejs` within trophyim. You'll need to change the variable `TROPHYIM_BOSH_SERVICE` in `trophyim.js` file to `http://localhost:7070/http-bind/`. Direct access to that URL from the chat client will result in a cross-origin request error in most browsers.

In Chrome you should see a message such as

```text
XMLHttpRequest cannot load http://localhost:7070/http-bind/.
Origin http://localhost is not allowed by Access-Control-Allow-Origin.
```

Change the `TROPHYIM_BOSH_SERVICE` variable to `http://localhost/bosh`. We'll now configure Apache httpd to proxy that URL to `http://localhost:7070/http-bind/`.

### Configure Apache httpd as a proxy

Edit `conf/httpd.conf` located in the Apache httpd installation folder.

Enable the following lines by removing the comment character `#`

```conf
LoadModule proxy_module modules/mod_proxy.so

LoadModule proxy_connect_module modules/mod_proxy_connect.so

LoadModule proxy_http_module modules/mod_proxy_http.so

Include `conf/extra/httpd-vhosts.conf`
```

Next, edit `conf/extra/httpd-vhosts.conf` to remove any stray `VirtualHost` directives there, and add

```conf
    ProxyPass /bosh http://localhost:7070/http-bind/
    ProxyPassReverse /bosh http://localhost:7070/http-bind/
```

Restart Apache httpd and reload page `http://localhost/trophyim.0.3/index.html`. You should now have a running chat client. Log in. Run another instance of the chat client and log in with a different user. If both users are buddies you should be able to chat.

![trophyim](/assets/img/javascript-xmpp-strophejs.jpg)

Happy chatting!
