---
layout: default
title: C# Custom Attributes Example
tags: c# .net custom attribute programming
comments: true
---

The following example uses Linq to find all types in an assembly adorned with a particular custom attribute type. It should build and run on .NET Framework 3.5 and beyond. Note the use of AllowMultiple AttributeUsage.

```c#
using System;
using System.Linq;
using System.Reflection;

enum Version {
    Version1,
    Version2
}

[AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct,
   AllowMultiple = true)]
class VersionAttribute : Attribute
{
    public Version version;
}

[VersionAttribute(version = Version.Version1)]
[VersionAttribute(version = Version.Version2)]
class SomeClass1
{
}

[VersionAttribute(version = Version.Version1)]
class SomeClass2
{
}

class Program
{
    static void Main(string[] args)
    {
        // Linq query to retrieve all classes that are adorned with VersionAttribute
        Assembly assembly = Assembly.GetExecutingAssembly();
        var types = from type in assembly.GetTypes()
                    where Attribute.IsDefined(type, typeof(VersionAttribute))
                    select type;

        // print out information
        foreach (Type type in types)
        {
            Console.WriteLine("{0}", type.Name); // print class name
            var attrs = type.GetCustomAttributes(typeof(VersionAttribute), false);
            foreach (VersionAttribute version in attrs)
            {
                Console.WriteLine("\t{0}", version.version); // print version
            }
        }

        Console.ReadLine();
    }
}
```

Here's the output of the program

```text
SomeClass1
        Version1
        Version2
SomeClass2
        Version1
```
