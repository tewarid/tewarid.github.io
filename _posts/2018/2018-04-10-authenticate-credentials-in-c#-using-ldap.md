---
layout: default
title: Authenticate credentials in C# using LDAP
tags: c# ldap .net
comments: true
---
# Authenticate credentials in C# using LDAP

The following statement references types in assembly `System.DirectoryServices.dll`, needed to validate credentials using LDAP

```c#
using System.DirectoryServices.AccountManagement;
```

The following code illustrated how to check whether the credentials specified by a user are valid, and whether they are part of a specific group

```c#
PrincipalContext context = new PrincipalContext(ContextType.Domain, "domain name or ip address", "username", "password");

if (!context.ValidateCredentials("username", "password"))
{
    throw new Exception("Invalid username or password.");
}

UserPrincipal user = UserPrincipal.FindByIdentity(context, "username");
GroupPrincipal group = GroupPrincipal.FindByIdentity(context, "group");

if (user == null || group == null)
{
    throw new Exception("Invalid username or group.");
}

if (!user.IsMemberOf(group))
{
    throw new Exception($"Username not a member of group.");
}
```

You can use `systeminfo` command in the command shell to find the domain name, or in PowerShell use

```powershell
echo $env:USERDOMAIN
```
