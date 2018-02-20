---
layout: default
title: Cross-platform applications using Avalonia
tags: avalonia wpf windows linux macos .net
---

# Cross-platform applications using Avalonia

Avalonia is a library for making cross-platform GUI applications that targets .NET framework and .NET Core. In this post, we'll use the later. GUI is defined in XAML and rendered using toolkits native to each platform such as WPF on Windows.

Install templates for .NET core

https://github.com/AvaloniaUI/avalonia-dotnet-templates

dotnet new --install .

Create a new GUI application
dotnet new avalonia.app -o MyApp

dotnet add package Avalonia.Gtk3 --version 0.5.2-alpha*

```
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp2.0</TargetFramework>
    <ApplicationIcon>myapp.ico</ApplicationIcon>
  </PropertyGroup>
  <ItemGroup>
    <Compile Update="**\*.xaml.cs">
      <DependentUpon>%(Filename)</DependentUpon>
    </Compile>
    <EmbeddedResource Include="**\*.xaml">
      <SubType>Designer</SubType>
    </EmbeddedResource>
  </ItemGroup>
  <ItemGroup>
    <PackageReference Include="Avalonia" Version="0.5.2-alpha*" />
    <PackageReference Include="Avalonia.Gtk3" Version="0.5.2-alpha*" />
    <PackageReference Include="Avalonia.Skia.Desktop" Version="0.5.2-alpha*" />
    <PackageReference Include="Avalonia.Win32" Version="0.5.2-alpha*" />
  </ItemGroup>
  <ItemGroup>
    <EmbeddedResource Include="myapp.ico" />
  </ItemGroup>
</Project>
```

Click binding https://github.com/AvaloniaUI/Avalonia/issues/1153