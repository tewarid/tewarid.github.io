---
layout: default
title: Authenticate credentials in C# using LDAP
tags: c# ldap .net
comments: true
---
# Authenticate credentials in C# using LDAP

In this post, we'll use the [C# interactive shell](https://github.com/dotnet/roslyn/wiki/Interactive-Window) to authenticate a user's credentials against an LDAP directory service such as Active Directory.

Let's start by loading the assembly that contains the type we need

```c#
#r "System.DirectoryServices.dll"
```

Next, let's import the namespace that contains the type

```c#
using System.DirectoryServices.AccountManagement;
```

Next, we create a `PricipalContext` instance with a domain name

```c#
var context = new PrincipalContext(ContextType.Domain, "name");
```

You can use `systeminfo` command in the command shell to find the domain name, or in PowerShell, use

```powershell
echo $env:USERDOMAIN
```

Next, we call `ValidateCredentials` with a username and password

```c#
var isValid = context.ValidateCredentials("username", "password");
```

If the username and password combination is valid, the following should print `true`

```c#
Console.WriteLine(isValid);
```
