---
layout: default
title: .NET Core class library solution from scratch
tags: update
---

This post documents using the `dotnet` command to create a class library solution from scratch. The solution builds a class library project, and a MS unit test project that tests the class library.

To create an empty solution called `MySolution.sln`

```bash
dotnet new sln [--force] -n MySolution
```

`sln` is just one of several templates supported by the command. To see a list, try `dotnet new -l`. Additional templates can be installed using `dotnet new --install` e.g. [AvaloniaUI](https://github.com/AvaloniaUI/avalonia-dotnet-templates).

To create a new class library project

```bash
dotnet new classlib [--force] -n MyLibrary
```

This creates a folder called `MyLibrary` and a `MyLibrary.csproj` file in it. Any C# files in the `MyLibrary` folder will be compiled during build.

If `MyLibrary` exists, use `--force` to replace the exiting project file.

If your project has an `AssemblyInfo.cs` that contains assembly attributes, you can edit project file to exclude autogeneration of assembly attributes

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netstandard2.0</TargetFramework>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.CSharp" Version="4.4.0" />
  </ItemGroup>

</Project>
```

Otherwise, you'll get errors such as

```text
obj/Debug/netcoreapp2.0/MyLibrary.AssemblyInfo.cs(10,12): error CS0579: Duplicate 'System.Reflection.AssemblyCompanyAttribute' attribute ...
```

Also, note the use of `Microsoft.CSharp` package in the project file. That is required to use C# language features such as dynamic. Without it, you'll get an error such as

```text
MyClass.cs(177,50): error CS0656: Missing compiler required member 'Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo.Create'
```

To add package reference, head into the `MyLibrary` project folder and run

```bash
dotnet add MyLibrary.csproj package Microsoft.CSharp
```

Then, run the following to restore package(s) from nuget

```bash
dotnet restore
```

Head over to the solution folder. To add the class library project to the solution, and build the solution

```bash
dotnet sln [MySolution.sln] add MyLibrary/MyLibrary.csproj
dotnet build
```

Specifying solution name is optional if you've got just one solution file in a folder.

To add a new MS unit test project

```bash
dotnet new mstest [--force] -n MyLibraryTest
```

Head into `MyLibraryTest` and add a reference to `MyLibrary` and package references

```bash
dotnet add MyLibraryTest.csproj reference ../MyLibrary/MyLibrary.csproj
dotnet add MyLibraryTest.csproj package Microsoft.CSharp
dotnet restore
```

Head over to the solution folder, build, and run unit tests

```bash
dotnet build
dotnet test MyLibraryTest
```

That wraps up the basic usage of `dotnet` to create and maintain a simple .NET Core class library project.