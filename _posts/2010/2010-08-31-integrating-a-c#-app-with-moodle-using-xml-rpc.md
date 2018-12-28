---
layout: default
title: Integrating a C# app with Moodle using XML-RPC
tags: c# .net moodle xml rpc mnet
comments: true
---
# Integrating a C# app with Moodle using XML-RPC

We'll make RPC calls to Moodle using MNet with a simple example. Our objective is to check if a username and password combination is valid, using the email auth plugin.

## What we need

We'll be using the following tools in this post

* A C# compiler, or the free Visual C# Express IDE

* An XML-RPC library, the one we'll use can be obtained at [http://xml-rpc.net/](http://xml-rpc.net/)

* SQL Server 2008 Express database

* Moodle installation (version 1.9.9+) using an external database (we use SQL Server 2008 Express)

## Enable MNet networking in Moodle

Use the admin page to enable MNet networking. Instructions to do so are provided in the Moodle Docs at [https://docs.moodle.org/32/en/MNet](https://docs.moodle.org/32/en/MNet).

## Add Trusted Hosts

Add the IP address from where you'll make the calls, to the list of trusted hosts. You then don't need to use encryption in XML-RPC calls, but don't use this over a public network. On the site administration page navigate to Networking, XML-RPC hosts.

## Publish methods through MNet

Modify the auth email plugin located at `auth\email\auth.php`, to publish its methods through MNet

```php
/**
* Provides the allowed RPC services from this class as an array.
*
* @return array Allowed RPC services.
*/
function mnet_publishes() {
  $servicelist = array();

  $service['name'] = 'auth';
  $service['apiversion'] = 1;
  $service['methods'] = array('user_login');
  $servicelist[] = $service;

  return $servicelist;
}
```

## Add RPC calls to the Moodle database

Update MNet service database tables to allow RPC calls. Run the following SQL statements using SQL Server Management Studio. If you use any other database, you may need to tweak the SQL syntax a bit. 

```sql
SET IDENTITY_INSERT [moodle].[dbo].[mdl_mnet_rpc] ON
GO
INSERT INTO [moodle].[dbo].[mdl_mnet_rpc]
(id,[function_name],[xmlrpc_path],[parent_type],[parent],[enabled],[help],[profile])
VALUES
(15,'user_login','auth/email/auth.php/user_login','email','auth',1,'','')
GO
SET IDENTITY_INSERT [moodle].[dbo].[mdl_mnet_rpc] OFF
GO
SET IDENTITY_INSERT [moodle].[dbo].[mdl_mnet_service] ON
GO
INSERT INTO [moodle].[dbo].[mdl_mnet_service]
(id,[name],[description],[apiversion],[offer])
VALUES
(4,'auth','auth','1',1)
GO
SET IDENTITY_INSERT [moodle].[dbo].[mdl_mnet_service] OFF
GO
SET IDENTITY_INSERT [moodle].[dbo].[mdl_mnet_service2rpc] ON
GO
INSERT INTO [moodle].[dbo].[mdl_mnet_service2rpc]
(id,[serviceid],[rpcid])
VALUES
(15,4,15)
GO
SET IDENTITY_INSERT [moodle].[dbo].[mdl_mnet_service2rpc] OFF
GO
INSERT INTO [moodle].[dbo].[mdl_mnet_host2service]
([hostid],[serviceid],[publish],[subscribe])
VALUES
(0,4,1,1)
GO
```

## Create C# app

The following code shows how you can use XML-RPC to call the method `user_login`.

First, we need to create an interface that will be implemented by the xmlrpc.net framework

```c#
public interface IMoodle : IXmlRpcProxy
{
  [XmlRpcMethod("system/listMethods")]
  string [] ListMethods();
  [XmlRpcMethod("auth/email/auth.php/user_login")]
  bool Login(string user, string password);
}
```

Next, we create a proxy for the interface, set the service URL and call the method

```c#
private IMoodle moodleProxy;
moodleProxy = XmlRpcProxyGen.Create();
moodleProxy.Url = "http://192.168.2.1/moodle/mnet/xmlrpc/server.php";
bool result = moodleProxy.Login("dkt", "pwd"); // returns true if successful or else false
```
