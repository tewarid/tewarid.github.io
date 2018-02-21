---
layout: default
title: Recursively copy to output in msbuild project
tags: msbuild xcopy
---

I have this very specific need to copy all files and folders from a source folder, to the project build output, akin to [xcopy](https://delog.wordpress.com/2013/01/09/xcopy/). Here's an AfterBuild target that does that.

```xml
  <Target Name="AfterBuild">
    <ItemGroup>
      <HtmlContentSource Include="..\html\**\*.*" Exclude="Web.config"/>
    </ItemGroup>
    <Message Text="### Copy HTML content ###" Importance="high" />
    <Copy
        SourceFiles="@(HtmlContentSource)"
        DestinationFiles="@(HtmlContentSource -> '$(OutputPath)\html\%(RecursiveDir)%(Filename)%(Extension)')"
        SkipUnchangedFiles="true"
    />
  </Target>
```

It uses [MSBuild transforms](https://msdn.microsoft.com/en-us/library/ms171476.aspx).
