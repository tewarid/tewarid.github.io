---
layout: default
title: Manipulating JSON using Json.NET
tags: json json.net .net javascript c# programming
comments: true
---
# Manipulating JSON using Json.NET

[Json.NET](https://github.com/JamesNK/Newtonsoft.Json) makes it convenient to manipulate [JSON](https://tools.ietf.org/html/rfc7159) in C# using dynamic programming. Let's start with a JSON representation we want to create

```javascript
{
    "menu": {
        "id": "file",
        "value": "File",
        "popup": {
            "menuitem": [
                {
                    "value": "New",
                    "onclick": "CreateNewDoc()"
                },
                {
                    "value": "Open",
                    "onclick": "OpenDoc()"
                },
                {
                    "value": "Close",
                    "onclick": "CloseDoc()"
                }
            ]
        }
    }
}
```

Here's how the Json.NET object representation can be created in C# using dynamic programming

```c#
dynamic jobj = JObject.FromObject(new 
{
    menu = new
    {
        id = "file",
        value = "File",
        popup = new
        {
            menuitem = new []
            {
                new
                {
                    value = "New",
                    onclick = "CreateNewDoc()"
                },
                new
                {
                    value = "Open",
                    onclick = "OpenDoc()"
                },
                new
                {
                    value = "Close",
                    onclick = "CloseDoc()"
                }
            }
        }
    }
});
```

To serialize it

```c#
var json = JsonConvert.SerializeObject(jobj);
Console.WriteLine(json);
```

To deserialize JSON string representation to dynamic object

```c#
dynamic jobj = JsonConvert.DeserializeObject(json);
Console.WriteLine(jobj.menu.id);
```

It is fairly easy to extend the object representation and add new items

```c#
jobj.foo = new JArray()
{
    new JObject() {
        new JProperty("bar", 10)
    },
    new JObject() {
        new JProperty("bar", 20)
    }
};
```

That adds a new property to jobj called foo that references a new array containing two objects.
