---
layout: default
title: Check if C# object is an array and iterate over it
tags: c# array check .net
---

Sometimes, you want to know if an object is an array. One way to do it is

```c#
if (obj.GetType().IsArray) {
  ...
}
```

Another way you can do it is

```c#
if (obj is Array) {
  // ...
}
```

The advantage of using the Array type is that you can iterate over an array without bothering about the type of the objects it holds

```c#
foreach (object o in (Array)obj)
{
  // ...
}
```

To set the value at a particular array index, iterate using a for loop

```c#
for (int i = 0; i < ((Array)obj).Length; i++)
{
  ((Array)obj).SetValue(someval, i);
}
```

To wrap it up, obtain the type of the elements of an array thus

```c#
obj.GetType().GetElementType()
```
