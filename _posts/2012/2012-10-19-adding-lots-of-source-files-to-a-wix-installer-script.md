---
layout: default
title: Adding lots of source files to a WiX installer script
tags: wix tool installer setup windows xml node nodejs
comments: true
---
# Adding lots of source files to a WiX installer script

Now that Visual Studio has dropped support for creating installers, I have taken to studying the [WiX Toolset](http://wixtoolset.org/) quite earnestly. Manually editing the WiX script is all right as long you have a handful of files. A particular installer I am working on has over nine hundred. I need to bundle the Node.js [executable](http://nodejs.org/dist/latest/node.exe) along with all the modules.

A quick look at the WiX documentation revealed the heat tool, that when executed thus produces a script file with elements that we can copy and paste into your wxs

```cmd
"c:\Program Files (x86)\WiX Toolset v3.6\bin\heat.exe" dir . -o out.wxs -cg MyComponentGroup -sfrag -gg -g1
```

The dir option followed by a `.` tells `heat` to gather the directory structure (source file) information from the current folder and its children. The `cg` option tells it to create a ComponentGroup with an id of `MyComponentGroup`. The `sfrag` option tells it to suppress wrapping individual directories and components in a Fragment element. The `gg` and `g1` options tell it to generate GUIDs for the components, but without the curly braces.

The `Component` elements can be copied from within the `TARGETDIR` `DirectoryRef` element in `out.wxs` to the target wxs. Similarly, the list of `ComponentRef` elements in the `MyComponentGroup` `ComponentGroup` can be copied into the `Feature` element of the target wxs.

## A Sample Wix Installer Script

The following installer script can serve as a starting point for your installer. It does several things

* Install files and folders to User's Local AppData folder

* Add shortcut to node.exe in the Start menu and on the Desktop

* Add a shortcut to uninstall the app in the Start menu

* Uninstall older version when upgrading

* Allow killing node.exe during uninstall if it is in execution

* Customizing the icons and bitmaps that appear in the installer UI

```xml
<?xml version="1.0" encoding="UTF-8"?>

<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi"
  xmlns:util="http://schemas.microsoft.com/wix/UtilExtension">

<Product Id="*"
  UpgradeCode="UpgradeCodeGuidHere"
  Version="1.0.0.0"
  Language="1033"
  Name="My Demo App"
  Manufacturer="My Demo App Inc">

<Package InstallerVersion="300" Compressed="yes"/>
<Media Id="1" Cabinet="myapp.cab" EmbedCab="yes" />

<Directory Id="TARGETDIR" Name="SourceDir">
  <Directory Id="LocalAppDataFolder">
    <Directory Id="ApplicationRootDirectory" Name="My Demo App"/>
  </Directory>
  <Directory Id="ProgramMenuFolder">
    <Directory Id="ApplicationStartMenuDirectory" Name="My Demo App"/>
  </Directory>
  <Directory Id="DesktopFolder" Name="Desktop" />
</Directory>

<DirectoryRef Id="ApplicationRootDirectory">
  <Component Id="cmp682D63F52C6A923093FEEB4843C1FC57" Guid="guid">
      <File Id="filF0E5F101F1A0BB7301C185E556B17884" KeyPath="yes" Source="SourceDir\LICENSE.rtf" />
  </Component>
  <Directory Id="dir5C9B5A0C45E6936E7334A1337C6A9713" Name="node">
    <Component Id="cmpF3997DF7D71AE597262E9BD72AAAD3C7" Guid="guid">
        <File Id="fil033B52E95F09B7F012231C998D1CAF39" KeyPath="yes" Source="SourceDir\node\node.exe" />
        <RemoveFolder Id='ApplicationRootDirectory' On='uninstall' />
    </Component>
    <Component Id="cmp38789F507892CB5C87E1B0156C91C74C" Guid="guid">
        <File Id="filF09913762744568C85CCB592BE253DC0" KeyPath="yes" Source="SourceDir\node\main.js" />
    </Component>
  </Directory>
</DirectoryRef>

<Icon Id="icon.ico" SourceFile="icon.ico"/>

<DirectoryRef Id="ApplicationStartMenuDirectory">
    <Component Id="ApplicationShortcuts" Guid="guid">
        <Shortcut Id="ApplicationStartMenuShortcut"
                  Name="My Demo App"
                  Directory="ApplicationStartMenuDirectory"
                  Target="[ApplicationRootDirectory]node.exe"
                  Arguments="main.js"
                  WorkingDirectory="dir5C9B5A0C45E6936E7334A1337C6A9713"
                  Icon="icon.ico"/>
        <Shortcut Id="ApplicationDesktopShortcut"
                  Name="My Demo App"
                  Directory="DesktopFolder"
                  Target="[ApplicationRootDirectory]node.exe"
                  Arguments="main.js"
                  WorkingDirectory="dir5C9B5A0C45E6936E7334A1337C6A9713"
                    Icon="icon.ico"/>
        <Shortcut Id="ApplicationFolderShortcut"
                  Name="Installation Folder"
                  Directory="ApplicationStartMenuDirectory"
                  Target="[ApplicationRootDirectory]"/>
        <Shortcut Id="ApplicationUninstallShortcut"
                  Name="Uninstall My Demo App"
                  Directory="ApplicationStartMenuDirectory"
                  Target="[SystemFolder]msiexec.exe"
                  Arguments="/x [ProductCode]"/> 
        <RemoveFolder Id="ApplicationStartMenuDirectory" On="uninstall"/>
        <RegistryValue Root="HKCU" Key="Software\My Demo App Inc\My Demo App" Name="installed" Type="integer" Value="1" KeyPath="yes"/>
    </Component>
</DirectoryRef>

<Feature Id="MainApplication" Title="Main Application" Level="1">
  <ComponentRef Id="cmp682D63F52C6A923093FEEB4843C1FC57" />
  <ComponentRef Id="cmpF3997DF7D71AE597262E9BD72AAAD3C7" />
  <ComponentRef Id="cmp38789F507892CB5C87E1B0156C91C74C" />
  <ComponentRef Id="ApplicationShortcuts" />
</Feature>

<WixVariable Id="WixUILicenseRtf" Value="LICENSE.rtf" />
<!--WixVariable Id="WixUIBannerBmp" Value="bmp" /--> <!-- 493 X 58 -->
<!--WixVariable Id="WixUIDialogBmp" Value="bmp" /--> <!-- 493 X 312 -->
<Property Id="ARPPRODUCTICON" Value="icon.ico" />
<Property Id="WixAppFolder" Value="WixPerUserFolder" />
<UIRef Id="WixUI_Minimal" />

<Upgrade Id="UpgradeCodeGuidHere">
   <UpgradeVersion
      Minimum="1.0.0.0" Maximum="99.0.0.0"
      Property="PREVIOUSVERSIONSINSTALLED"
      IncludeMinimum="yes" IncludeMaximum="no" />
</Upgrade>

<InstallExecuteSequence>
  <RemoveExistingProducts After="InstallInitialize" />
</InstallExecuteSequence>

<util:CloseApplication Id="CloseApplication" Target="[dir5C9B5A0C45E6936E7334A1337C6A9713]node.exe"/>

</Product>

</Wix>
```

Remember to replace `UpgradeCodeGuidHere` with a valid GUID. GUIDs can be generated by executing `guidgen.exe` from Visual Studio's Developer Command Prompt. Choose the registry format and remove the braces. There are also quite a few online GUID generators.

## Compiling and linking

To compile the above script using the WiX compiler, execute

```cmd
candle.exe demo.wxs -ext WixUtilExtension
```

To link the object file produced by the compiler and create an msi, execute

```cmd
light.exe -out demo.msi demo.wixobj -ext WixUIExtension -ext WixUtilExtension
```

You can put both steps in a batch file

```cmd
set WIX_BIN=c:\Program Files (x86)\WiX Toolset v3.6\bin\
echo Wix Toolset Bin Path: %WIX_BIN%
"%WIX_BIN%candle.exe" demo.wxs -ext WixUtilExtension
if exist demo.wixobj (
  "%WIX_BIN%light.exe" -out demo.msi demo.wixobj -ext WixUIExtension -ext WixUtilExtension
)
```
