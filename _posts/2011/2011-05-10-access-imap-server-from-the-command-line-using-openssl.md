---
layout: default
title: Access IMAP server from the command line using OpenSSL
tags: imap command line openssl
comments: true
---

In this post, we'll use OpenSSL to gain access to an [IMAP](http://tools.ietf.org/html/rfc2060) mail server. The mail server we'll use is Google's GMail. If you are running Linux, you should have openssl installed. On Windows, obtain and install the [Win32 version](http://www.slproweb.com/products/Win32OpenSSL.html) of OpenSSL. If your IMAP server does not support SSL, you can use the excellent netcat utility on Linux, [Ncat](http://nmap.org/ncat/) utility that comes with [Nmap](http://nmap.org/) on Windows or regular telnet.

### Connect

Issue the following command to begin an SSL session with the IMAP server

```bash
openssl s_client -crlf -connect imap.gmail.com:993
```

You'll get an output such as the following that can be suppressed by adding the `-quiet` option to the command above

<!-- highlight 69,70 -->

```text
CONNECTED(00000003)
depth=1 /C=US/O=Google Inc/CN=Google Internet Authority
verify error:num=20:unable to get local issuer certificate
verify return:0
---
Certificate chain
 0 s:/C=US/ST=California/L=Mountain View/O=Google Inc/CN=imap.gmail.com
   i:/C=US/O=Google Inc/CN=Google Internet Authority
 1 s:/C=US/O=Google Inc/CN=Google Internet Authority
   i:/C=US/O=Equifax/OU=Equifax Secure Certificate Authority
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIDWzCCAsSgAwIBAgIKaNPuGwADAAAisjANBgkqhkiG9w0BAQUFADBGMQswCQYD
VQQGEwJVUzETMBEGA1UEChMKR29vZ2xlIEluYzEiMCAGA1UEAxMZR29vZ2xlIElu
dGVybmV0IEF1dGhvcml0eTAeFw0xMTAyMTYwNDQzMDRaFw0xMjAyMTYwNDUzMDRa
MGgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1N
b3VudGFpbiBWaWV3MRMwEQYDVQQKEwpHb29nbGUgSW5jMRcwFQYDVQQDEw5pbWFw
LmdtYWlsLmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAqfPyPSEHpfzv
Xx+9zGUxoxcOXFrGKCbZ8bfUd8JonC7rfId32t0gyAoLCgM6eU4lN05VenNZUoCh
L/nrX+ApdMQv9UFV58aYSBMU/pMmK5GXansbXlpHao09Mc8eur2xV+4cnEtxUvzp
co/OaG15HDXcr46c6hN6P4EEFRcb0ccCAwEAAaOCASwwggEoMB0GA1UdDgQWBBQj
27IIOfeIMyk1hDRzfALz4WpRtzAfBgNVHSMEGDAWgBS/wDDr9UMRPme6npH7/Gra
42sSJDBbBgNVHR8EVDBSMFCgTqBMhkpodHRwOi8vd3d3LmdzdGF0aWMuY29tL0dv
b2dsZUludGVybmV0QXV0aG9yaXR5L0dvb2dsZUludGVybmV0QXV0aG9yaXR5LmNy
bDBmBggrBgEFBQcBAQRaMFgwVgYIKwYBBQUHMAKGSmh0dHA6Ly93d3cuZ3N0YXRp
Yy5jb20vR29vZ2xlSW50ZXJuZXRBdXRob3JpdHkvR29vZ2xlSW50ZXJuZXRBdXRo
b3JpdHkuY3J0MCEGCSsGAQQBgjcUAgQUHhIAVwBlAGIAUwBlAHIAdgBlAHIwDQYJ
KoZIhvcNAQEFBQADgYEAxHVhW4aII3BPrKQGUdhOLMmdUyyr3TVmhJM9tPKhcKQ/
IcBYUev6gLsB7FH/n2bIJkkIilwZWIsj9jVJaQyJWP84Hjs3kus4fTpAOHKkLqrb
IZDYjwVueLmbOqr1U1bNe4E/LTyEf37+Y5hcveWBQduIZnHn1sDE2gA7LnUxvAU=
-----END CERTIFICATE-----
subject=/C=US/ST=California/L=Mountain View/O=Google Inc/CN=imap.gmail.com
issuer=/C=US/O=Google Inc/CN=Google Internet Authority
---
No client certificate CA names sent
---
SSL handshake has read 1866 bytes and written 281 bytes
---
New, TLSv1/SSLv3, Cipher is RC4-SHA
Server public key is 1024 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
SSL-Session:
    Protocol  : TLSv1
    Cipher    : RC4-SHA
    Session-ID: 2410BB675CA16A65B740B559BC10C0B406D3C48F48EB94DE48555F1E704D7A4E
    Session-ID-ctx:
    Master-Key: 5E51885143B7A320EA7EE1C5AFAA9160A716C453792C213D76FC85AADDAA89AC2C3BF1D29F567E648F5A460D8B558DFA
    Key-Arg   : None
    TLS session ticket lifetime hint: 100800 (seconds)
    TLS session ticket:
    0000 - b3 1f ec 8d cd bd 28 2e-4a 7d 78 92 d5 71 ff ef   ......(.J}x..q..
    0010 - b3 fe dd bf 03 eb 49 42-5f d5 0f 5e 5f 04 65 be   ......IB_..^_.e.
    0020 - 05 9e 6b 1c 4c d3 6b 05-1b ce 32 e4 2a 90 1b b0   ..k.L.k...2.*...
    0030 - df 8a 2b 4b e3 91 88 45-c1 97 d0 76 8a 5c b3 f2   ..+K...E...v.\..
    0040 - 0e 83 f7 d5 5c 52 44 c6-b1 bf b0 f3 42 73 5b 81   ....\RD.....Bs[.
    0050 - f4 bd d6 98 cb d5 eb a1-cb bb 51 9e 47 2e f1 0e   ..........Q.G...
    0060 - d3 2d 02 91 0d a6 f0 00-e0 0e a3 e2 68 f0 1a 13   .-..........h...
    0070 - f7 06 c2 a4 2b 8a 4a 6c-55 e9 5d ff 94 f0 45 8f   ....+.JlU.]...E.
    0080 - 2c 07 d9 04 d1 3b 7b ef-e4 ef 78 f6 48 1d 82 8d   ,....;{...x.H...
    0090 - 8b bb 67 a0 a8 d2 78 99-66 e3 44 b2 6c 75 81 b9   ..g...x.f.D.lu..
    00a0 - 2d ba 77 34                                       -.w4

    Start Time: 1305041542
    Timeout   : 300 (sec)
    Verify return code: 20 (unable to get local issuer certificate)
---
* OK Gimap ready for requests from 200.199.23.105 o16if3544685ybc.111
```

### Login

To login, issue the following command

```text
tag login user@gmail.com password
```

`tag` before login command is some character sequence required to be used before each subsequent IMAP command.

If that works you'll see an output such as

```text
* CAPABILITY IMAP4rev1 UNSELECT IDLE NAMESPACE QUOTA ID XLIST CHILDREN X-GM-EXT-1 UIDPLUS COMPRESS=DEFLATE
tag OK user@gmail.com User authenticated (Success)
```

### List Mailboxes

Issue the following command

```text
tag LIST "" "*"
```

This produce an output such as

```text
* LIST (\HasNoChildren) "/" "INBOX"
* LIST (\HasNoChildren) "/" "Notes"
* LIST (\Noselect \HasChildren) "/" "[Gmail]"
* LIST (\HasNoChildren) "/" "[Gmail]/All Mail"
* LIST (\HasNoChildren) "/" "[Gmail]/Drafts"
* LIST (\HasNoChildren) "/" "[Gmail]/Sent Mail"
* LIST (\HasNoChildren) "/" "[Gmail]/Spam"
* LIST (\HasNoChildren) "/" "[Gmail]/Starred"
* LIST (\HasChildren \HasNoChildren) "/" "[Gmail]/Trash"
```

### Select a mailbox

Issue the following command to select the INBOX

```text
tag SELECT INBOX
```

This produces an output such as

```text
* FLAGS (\Answered \Flagged \Draft \Deleted \Seen)
* OK [PERMANENTFLAGS (\Answered \Flagged \Draft \Deleted \Seen \*)]
* OK [UIDVALIDITY 2]
* 6385 EXISTS
* 0 RECENT
* OK [UIDNEXT 29210]
tag OK [READ-WRITE] INBOX selected. (Success)
```

### Mailbox status

Execute the following command to get the total number of messages in the selected Mailbox

```text
tag STATUS INBOX (MESSAGES)
```

The result is an output such as

```text
* STATUS "INBOX" (MESSAGES 6388)
```

### Fetch headers of last ten messages

Execute the command

```text
tag FETCH 6378:6388 (BODY[HEADER])
```

### Fetch message body

Execute the following command

```text
tag FETCH 6388 (BODY)
```

The number 6388 corresponds to the number of the last message above - the first message would be 1, and so on.

Message bodies are usually multipart - you can retrieve a particular part using

```text
tag FETCH 6388 (BODY[n])
```

`n` is a zero-indexed part number.

### Log out

Finally, to close the IMAP session

```text
tag LOGOUT
```
