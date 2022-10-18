---
layout: default
title: SSL/TLS decryption in Wireshark
tags: ssl tls wireshark dissector openssl
comments: true
---
# SSL/TLS decryption in Wireshark

Wireshark's [dissector for SSL](https://wiki.wireshark.org/SSL) is able to decrypt SSL/TLS, given the private key in PFX/P12 or PEM format. If you want to figure out whether you're using the right private key, you can [derive the public key](_posts/2017/2017-09-18-export-private-key-in-pfx-or-p12-file-to-pem-format.md) from it, and compare its modulus with the first certificate in the chain of certificates sent in the SERVER HELLO.

```text
$ openssl rsa -text -in key.pem -pubout
Private-Key: (2048 bit)
modulus:
00:97:c6:a5:01:d6:36:b3:25:fa:83:9c:93:75:dd:
bb:dc:f6:ef:78:b8:b5:cc:20:1c:35:9a:ba:3d:8d:
d3:94:9b:b0:b2:6c:e7:79:83:3c:07:37:1f:8f:e5:
02:f8:f4:ac:9b:7c:1a:b6:74:6f:73:f5:57:34:30:
5b:32:5a:3b:ba:bd:65:dc:cc:98:30:13:01:fb:0b:
3c:f3:e3:6c:da:9b:3d:47:1f:5f:c3:12:a2:4f:21:
dc:cc:39:90:9d:83:05:b3:06:40:d3:62:25:fe:8b:
e9:1e:ca:a2:d8:0f:9d:cd:84:10:62:15:0e:f3:ab:
cb:d6:fc:92:cf:ff:04:75:17:c6:c7:2d:d6:05:c6:
c1:ce:4e:77:c4:fc:fc:c5:ff:37:4f:83:bb:93:f9:
0f:2f:06:70:6a:55:37:e5:6f:0c:92:5e:14:99:0d:
87:2a:e6:d4:30:f9:de:fb:b5:c6:5e:e8:f5:98:5e:
19:4b:8f:53:8a:e5:f1:87:7b:69:99:4d:a0:55:02:
a0:57:5d:bf:ca:0b:84:8c:23:ed:f6:e5:7a:97:4b:
3e:3f:bb:38:29:0e:11:28:53:6d:d4:d8:69:88:5f:
2d:23:28:e6:43:97:e0:51:db:e8:a8:c7:c5:9f:c3:
9d:11:48:d3:51:8c:5f:ba:ab:c0:60:30:26:e2:c9:
54:8b
```

![TLS Modulus in Wireshark](/assets/img/wireshark-tls-modulus.png)
