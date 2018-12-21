---
layout: default
title: Hello World with .NET Core
tags: .net core c# vscode
comments: true
---
# Hello World with .NET Core

.NET Core is Microsoft's new cross-platform Command Language Runtime (CLR). This post is an elementary getting started guide where I create, build and run a "Hello World!" console application with .NET Core.

Let's begin by downloading and installing [.NET Core](https://www.microsoft.com/net/core) for your platform.

To create a new console application, run

```bash
mkdir project
cd project
dotnet new console
```

That will create two files - project.csproj and Program.cs. Edit Program.cs using your favorite editor.

I recommend using the multi-platform [VS Code](https://code.visualstudio.com/). You can extend the capabilities of VS Code by downloading extensions from the [VisualStudio Marketplace](https://marketplace.visualstudio.com/VSCode). VS Code should prompt you to download the [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) when you open Program.cs.

To build the new program from the command line run

```bash
dotnet build
```

To execute the program run

```bash
dotnet run
```

You can also edit, and run or debug the program using VS Code, as shown in this screenshot

![.NET CLR with VS Code](/assets/img/vscode-net-core-debug.png)

Console applications can be very powerful, but .NET CLR can also be used to build Web applications using [ASP.NET Core](https://docs.asp.net/en/latest/getting-started.html).
