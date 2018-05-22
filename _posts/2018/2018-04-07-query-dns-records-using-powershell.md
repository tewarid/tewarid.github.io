---
layout: default
title: Query DNS records using PowerShell
tags: dns powershell
comments: true
---

Using the [Resolve-DnsName](https://docs.microsoft.com/en-us/powershell/module/dnsclient/resolve-dnsname?view=winserver2012r2-ps)

```powershell
Resolve-DnsName -Name google.com -Server 8.8.8.8 -Type ANY
```

Here's what the output looks like

```text
Name                                           Type   TTL   Section    IPAddress
----                                           ----   ---   -------    ---------
google.com                                     A      299   Answer     172.217.30.46
google.com                                     AAAA   299   Answer     2800:3f0:4001:808::200e

Name         : google.com
QueryType    : MX
TTL          : 599
Section      : Answer
NameExchange : aspmx.l.google.com
Preference   : 10


Name      : google.com
QueryType : NS
TTL       : 21599
Section   : Answer
NameHost  : ns3.google.com


Name      : google.com
QueryType : TXT
TTL       : 3599
Section   : Answer
Strings   : {v=spf1 include:_spf.google.com ~all}


Name      : google.com
QueryType : NS
TTL       : 21599
Section   : Answer
NameHost  : ns2.google.com


Name                   : google.com
QueryType              : SOA
TTL                    : 59
Section                : Answer
NameAdministrator      : dns-admin.google.com
SerialNumber           : 191985437
TimeToZoneRefresh      : 900
TimeToZoneFailureRetry : 900
TimeToExpiration       : 1800
DefaultTTL             : 60


Name      : google.com
QueryType : NS
TTL       : 21599
Section   : Answer
NameHost  : ns4.google.com


Name         : google.com
QueryType    : MX
TTL          : 599
Section      : Answer
NameExchange : alt3.aspmx.l.google.com
Preference   : 40


Name         : google.com
QueryType    : MX
TTL          : 599
Section      : Answer
NameExchange : alt2.aspmx.l.google.com
Preference   : 30


Name         : google.com
QueryType    : MX
TTL          : 599
Section      : Answer
NameExchange : alt1.aspmx.l.google.com
Preference   : 20


Name         : google.com
QueryType    : MX
TTL          : 599
Section      : Answer
NameExchange : alt4.aspmx.l.google.com
Preference   : 50


Name      : google.com
QueryType : TXT
TTL       : 299
Section   : Answer
Strings   : {docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e}


Name      : google.com
QueryType : NS
TTL       : 21599
Section   : Answer
NameHost  : ns1.google.com
```