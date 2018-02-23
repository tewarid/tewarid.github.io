---
layout: default
title: HTTP/S capture using mitmproxy
tags: http https mitmproxy sniffer macos
---

This post shows how to install mitmproxy on MacOS (El Capitan) to capture HTTP/S traffic, especially useful when debugging applications.

I've been using Telerik Fiddler on Windows for sniffing HTTP/S and WebSocket traffic, but it isn't very reliable on Mac or Linux. mitmproxy fills the lacuna well, but it does not yet support WebSocket traffic.

### Install

Use pip to install mitmproxy thus

```bash
pip install mitmproxy
```

I encountered several compilation issues while installing through pip. I'll go through them one by one. The first error results from failure to compile cryptography

```text
    building '_openssl' extension
    clang -fno-strict-aliasing -fno-common -dynamic -I/usr/local/include -I/usr/local/opt/sqlite/include -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/usr/local/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/include/python2.7 -c build/temp.macosx-10.10-x86_64-2.7/_openssl.c -o build/temp.macosx-10.10-x86_64-2.7/build/temp.macosx-10.10-x86_64-2.7/_openssl.o
    build/temp.macosx-10.10-x86_64-2.7/_openssl.c:431:10: fatal error: 'openssl/aes.h' file not found
    #include <openssl/aes.h>
             ^
    1 error generated.
    error: command 'clang' failed with exit status 1
```

That can be resolved by executing pip to install cryptography thus

```bash
env LDFLAGS="-L$(brew --prefix openssl)/lib" CFLAGS="-I$(brew --prefix openssl)/include" pip install mitmproxy
```

With that dependency resolved, mitmproxy install fails with the following error

```text
    building 'lxml.etree' extension
    clang -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/usr/local/opt/openssl/include -I/usr/include/libxml2 -Isrc/lxml/includes -I/usr/local/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/include/python2.7 -c src/lxml/lxml.etree.c -o build/temp.macosx-10.10-x86_64-2.7/src/lxml/lxml.etree.o -w -flat_namespace
    In file included from src/lxml/lxml.etree.c:323:
    src/lxml/includes/etree_defs.h:14:10: fatal error: 'libxml/xmlversion.h' file not found
    #include "libxml/xmlversion.h"
             ^
    1 error generated.
    Compile failed: command 'clang' failed with exit status 1
    cc -I/usr/include/libxml2 -I/usr/include/libxml2 -c /var/folders/3v/zgzrr9h96_34db7lt9_fx1wr0000gn/T/xmlXPathInitdIvQjA.c -o var/folders/3v/zgzrr9h96_34db7lt9_fx1wr0000gn/T/xmlXPathInitdIvQjA.o
    /var/folders/3v/zgzrr9h96_34db7lt9_fx1wr0000gn/T/xmlXPathInitdIvQjA.c:1:10: fatal error: 'libxml/xpath.h' file not found
    #include "libxml/xpath.h"
             ^
    1 error generated.
    *********************************************************************************
    Could not find function xmlCheckVersion in library libxml2\. Is libxml2 installed?
    Perhaps try: xcode-select --install
    *********************************************************************************
```

Luckily, that error also shows the solution, run

```bash
xcode-select --install
```

Now, mitmproxy should install successfully.

### Run

To capture HTTP/S traffic using mitmproxy traffic, run

```bash
mitmproxy
```

mitmproxy should show which port it is listening at; 8080 is the default. Use http://localhost:8080 as the HTTP proxy setting in browsers and applications.

### Android emulator

This is how you can execute Android emulator to use mitmproxy as an HTTP proxy

```bash
export DYLD_FALLBACK_LIBRARY_PATH=~/Library/Android/sdk/tools/lib64
~/Library/Android/sdk/tools/emulator64-x86 -avd Nexus_S_API_21_x86 -http-proxy http://localhost:8080
```

The first line is needed so that the emulator can find the necessary libraries such as OpenGLES emulation library.

### Pinned Certificates

If you try to access any site in the Android browser, or run any application that uses HTTP/S, mitmproxy will capture all traffic. To capture SSL traffic mitmproxy presents its own certificate to the applications. The root certificate that mitmproxy uses will need to be added to the certificate store, to avoid failures in certificate chain validation. This can be done by navigating to the special [mitm.it](http://mitm.it) URL in the browser, and picking your platform from the resulting page.

If you use certificate pinning in your applications, you can add ~/.mitmproxy/mitmproxy-ca-cert.cer to the list of certificates.

### WebSocket traffic

mitmproxy does not support WebSocket traffic so connection establishment will fail. You can however setup mitmproxy to ignore traffic to a certain host:port. This can be leveraged to ask it to ignore WebSocket traffic.

```bash
mitmproxy --ignore 192\.168\.1\.10:888[1-9]
```
