---
layout: default
title: Create and use NuGet packages
tags: nuget .net
---

To follow the brief instructions in this post, you'll need to [download](https://dist.nuget.org/index.html) NuGet.

To create NuGet package spec, aka nuspec, from a project file, execute the following in the folder where the project file is located

```powershell
nuget spec
```

Edit the file appropriately.

To create a NuGet package (a glorified zip file) containing project output and all dependencies, run

```powershell
nuget pack ProjectName.csproj -IncludeReferencedProjects -Prop Configuration=Release -Prop Platform=AnyCPU
```

Packages can be distributed by creating account at, and uploading nupkg to, [nuget.org](https://www.nuget.org/packages/manage/upload).

Package references can be managed using NuGet Package Manager extension in Visual Studio (see option under Tools menu). Referenced packages are listed in the packages.config located in a project's folder; recommend adding it to source control. VS will download all packages specified there before the project is built. VS caches downloaded packages in the packages folder located in the solution's root folder; exclude it from source control.

nupkg files can also be distributed by other means, and added manually into project using the [Powershell commands](https://docs.nuget.org/ndocs/tools/powershell-reference) available in Package Management Console in VS

```powershell
Install-Package SomePackage -Source Path
```

SomePackage is a fully qualified package name, Path is an absolute or relative path containing the nupkg file.

Install-Package may fail with the following message, when packages need to be restored from custom source

```powershell
Install-Package : Some NuGet packages are missing from the solution. The packages need to be restored in order to build the dependency graph. Restore the packages before performing any operations.
```

To [restore](https://docs.nuget.org/consume/command-line-reference#restore-command) packages from custom source, use nuget command, thus

```powershell
nuget restore -Source Path
```

Note that Path has to be an absolute path; multiple paths can be separated by semicolon e.g. C:\packages;https://www.myget.org/F/nuget.
