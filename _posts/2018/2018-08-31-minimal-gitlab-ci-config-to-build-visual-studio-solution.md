---
layout: default
title: Minimal GitLab CI config to build Visual Studio solution
tags: gitlab ci cd visual studio
comments: true
---
# Minimal GitLab CI config to build Visual Studio solution

```yml
stages:
  - build

variables:
  nuget: 'C:\Gitlab-Runner\nuget.exe'
  msbuild: 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
  vstest: 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\Extensions\TestPlatform\vstest.console.exe'

compile:
  stage: build
  script:
    -  '%nuget% restore .\code\MyApp.sln'
    -  '"%msbuild%" .\code\MyApp.sln /t:Clean,Build /p:Configuration=Debug'
    - '"%vstest%" .\code\MyApp\bin\Debug\MyApp.exe'
```
