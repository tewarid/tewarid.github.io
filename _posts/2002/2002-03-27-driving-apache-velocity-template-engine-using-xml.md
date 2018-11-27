---
layout: default
title: Driving Apache Velocity template engine using XML
tags: xml apache velocity template
comments: true
---

The [Apache Velocity Runner](https://gist.github.com/tewarid/095b5dcfbaa6ebce7bd04829ada33951) merges an XML document such as

```xml
<!DOCTYPE velocity SYSTEM "velocity.dtd">

<velocity>
    <template root="c:\java\velocity" file="HelloVelocity.txt"/>
    <output root="c:\java\velocity" file="HelloVelocity.out.txt"/>
    <context>
        <property name="Name" value="Devendra Tewari"/>
        <list name="lastaccesses">
            <object>
                <property name="time" value="12/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="31/12/2001 18:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="12/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="12/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
            <object>
                <property name="time" value="16/12/2001 13:30"/>
                <property name="computer" value="abc"/>
            </object>
        </list>
    </context>
</velocity>
```

With a template such as

```text
Hello $Name!

Last $!{lastaccesses.size()} accesses:
#foreach($access in $lastaccesses)
    ${velocityCount}. $access.time from $access.computer
#end

$!silent
```

To produce the following output

```text
Hello Devendra Tewari!

Last 5 accesses:
    1. 12/12/2001 13:30 from abc
    2. 31/12/2001 18:30 from abc
    3. 12/12/2001 13:30 from abc
    4. 12/12/2001 13:30 from abc
    5. 16/12/2001 13:30 from abc

```

The XML document schema is [available as a DTD](https://gist.github.com/tewarid/36e84becaf72cea99ef9786eac0fd164).
