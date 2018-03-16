---
layout: default
title: Lists and sorting in .NET
tags: .net c# sorting programming
comments: true
---

.NET Framework provides a generic SortedList class that keeps objects sorted by Key while they are added. It requires Key to be unique, probably for performance reasons. The example below demonstrates the alternative List<T> class for sorting and searching, and the limitation of SortedList while trying to do the same thing. You'll probably get better performance out of SortedList. List has a BinarySearch method that can improve search performance significantly.

```c#
using System;
using System.Collections.Generic;
using System.Linq;

namespace ListExample
{
    class Person
    {
        public string name;
        public byte age;

        public Person(string name, byte age)
        {
            this.name = name;
            this.age = age;
        }
    }

    class CompareByAge : IComparer<Person>
    {
        public int Compare(Person x, Person y)
        {
            return x.age - y.age;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Person luisa = new Person("Luisa", 7);
            Person victoria = new Person("Victoria", 10);
            Person alice = new Person("Alice", 10);
            Person lara = new Person("Lara", 1);
            Person rafaela = new Person("Rafaela", 9);
            Person noname = new Person("Noname", 6);
            Person p;

            Console.WriteLine("Sorting with List:");
            List<Person> list = new List<Person>();
            list.Add(luisa);
            list.Add(victoria);
            list.Add(alice);
            list.Add(lara);
            list.Add(rafaela);

            // Sort using System.Collections.Generic.IComparer<T>
            list.Sort(new CompareByAge());

            // Sort using the System.Comparison<T> delegate
            //list.Sort(delegate(Person x, Person y) {
            //    return x.age - y.age;
            //});

            foreach (Person person in list)
            {
                Console.WriteLine(person.name);
            }

            Console.WriteLine();

            Console.WriteLine("Find with List:");
            //p = list[list.FindIndex(0, person => person.age >= noname.age)];
            //p = list.Find(person => person.age >= noname.age);
            int i = list.BinarySearch(noname, new CompareByAge());
            i = i < 0 ? ~i : i;
            if (i == list.Count)
            {
                Console.WriteLine("No one that old here");
            }
            else
            {
                p = list[i];
                Console.WriteLine(p.name);
            }

            Console.WriteLine();

            Console.WriteLine("Sorting with SortedList:");
            SortedList<byte, Person> sortedList = new SortedList<byte, Person>();
            sortedList.Add(luisa.age, luisa);
            sortedList.Add(victoria.age, victoria);
            //sortedList.Add(alice.age, alice); // throws System.ArgumentException
            sortedList.Add(lara.age, lara);
            sortedList.Add(rafaela.age, rafaela);

            foreach (Person person in sortedList.Values)
            {
                Console.WriteLine(person.name);
            }

            Console.WriteLine();

            Console.WriteLine("Find with SortedList:");
            try
            {
                p = sortedList.First(keyValue => keyValue.Key >= noname.age).Value;
                Console.WriteLine(p.name);
            }
            catch(InvalidOperationException)
            {
                Console.WriteLine("No one that old here");
            }

            Console.ReadLine();
        }
    }
}
```

Here's the output produced by the example

```text
Sorting with List:
Lara
Luisa
Rafaela
Victoria
Alice

Find with List:
Luisa

Sorting with SortedList:
Lara
Luisa
Rafaela
Victoria

Find with SortedList:
Luisa
```
