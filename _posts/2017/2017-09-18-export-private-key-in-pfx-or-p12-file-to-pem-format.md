---
layout: default
title: Export private key in pfx or p12 file to pem format
tags: pfx p12 pem openssl
comments: true
---
# Export private key in pfx or p12 file to pem format

The following openssl command can be used to export private key and certificate in a pfx or p12 file to pem

```bash
openssl pkcs12 -nodes -in file.pfx -out key.pem -passin pass:foobar
```

Add  `-nocerts` if you don't want to export certificate.

If you need the public key for the private key in key.pem

```bash
openssl rsa -in key.pem -out key.pub -pubout
```

If you need information on the public key (modulus, exponent...)

```bash
openssl rsa -pubin -in key.pub -text
```

You can also obtain the same information from the private key file

```bash
openssl rsa -in key.pem -pubout -text
```

If you need to create pfx from private key and certificate in pem format

```bash
openssl pkcs12 -inkey key.pem -in cert.pem -export -out file.pfx  -passout pass:foobar
```
