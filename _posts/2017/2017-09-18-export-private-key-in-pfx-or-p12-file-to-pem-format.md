---
layout: default
title: Export private key in pfx or p12 file to pem format
tags: pfx p12 pem openssl
---

The following openssl command can be used to export private key in a pfx or p12 file to pem

```bash
openssl pkcs12 -nodes -in file.pfx -out key.pem -nocerts
```

If you need the public key for the private key in key.pem

```bash
openssl rsa -in key.pem -out key.pub -pubout
```

If you need information on the public key (modulus, exponent...)

```bash
openssl rsa -in key.pem -pubout -text
```

OR

```bash
openssl rsa -pubin -in key.pub -text
```

If you need to create pfx from private key and certificate in pem format

```bash
openssl pkcs12 -inkey key.pem -in cert.pem -export -out file.pfx
```
