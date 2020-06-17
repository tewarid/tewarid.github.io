---
layout: default
title: Self-sign UWP appx or appxbundle for side-loading
tags: windows uwp side load appx appxbundle
comments: true
---
# Self-sign UWP appx or appxbundle for side-loading

Windows 10 apps built for side-loading are written to a directory with the `_Test` suffix, that also contains a PowerShell script called `Install.ps1` to automate side-loading. This post shows how you can side-load an as yet unsigned appx or appxbundle.

First, you'll need to [create](https://docs.microsoft.com/en-us/windows/msix/package/create-certificate-package-signing) a self-signed certificate for package signing.

In PowerShell, run

```powershell
New-SelfSignedCertificate -Type Custom -Subject "CN=MyCompany" -KeyUsage DigitalSignature -FriendlyName "MyCompany Test Cert" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
```

Open developer command prompt of Visual Studio and [run](https://docs.microsoft.com/en-us/windows/msix/package/sign-app-package-using-signtool)

```text
SignTool sign /fd sha256 /a /n MyCompany MyApp_x86.appxbundle
```

Use `/p` option to specify password if needed.

Note that Subject should match Publisher attribute of Identity element in `Package.appxmanifest` or `AppxManifest.xml`, or signing will fail with

```text
SignTool Error: An unexpected internal error has occurred.
Error information: "Error: SignerSign() failed." (-2147024885/0x8007000b)
```

Now, you can run `Install.ps1` to side-load the app. If side-loading fails, you've probably not [enabled it](https://www.windowscentral.com/how-enable-windows-10-sideload-apps-outside-store) in Settings.
