---
layout: default
title: Improving query performance when using Entity Framework
tags: dotnet .net c# entity framework linq
comments: true
---

These are some lessons I learned when improving query performance of an application written in C#, that uses Entity Framework [Code First](https://msdn.microsoft.com/en-us/library/jj193542.aspx), LINQ, and SQL Server

1. Databases cache query plans&mdash;the first request may take longer, but subsequent requests are much faster. A LINQ to SQL query is an IQueryable, reuse it when possible.

2. Use the select operator to return just the data you need. Returning whole objects, and data you don't need, translates to a more time-consuming remote procedure call (RPC) to the database.

3. Perform filtering&mdash;using where operator&mdash;at the database. If you use the Where method of IQueryable, with a lambda expression that calls C# methods, the query will be performed on the IEnumerable returned from the database.

4. Perform sorting after filtering. This can be done using the orderby operator, but also using OrderBy method of IQueryable with a lambda expression.

5. Restrict the number of records returned from the database to some maximum value&mdash;1000 works fine&mdash;using the Take method of IQueryable.

6. Pagination can be used to further reduce the data returned, using Skip method of IQueryable to skip records you don't need, followed by Take method to pick the records you do need.

7. If you want to use string value of an Enum in a query, use ToString() method on Enum object. LINQ to SQL sends string values of Enum to the database, hence the query suffers no significant performance issues.

See [Performance Considerations](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ef/performance-considerations) for more.
