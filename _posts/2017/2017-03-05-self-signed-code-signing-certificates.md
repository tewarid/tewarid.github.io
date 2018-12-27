---
layout: default
title: Self-signed code signing certificates
tags: update
comments: true
---
# Self-signed code signing certificates

Some setup and application executables need to be signed so that they are **not** [flagged as a security risk](https://www.symantec.com/security_response/writeup.jsp?docid=2010-090200-5010-99&tabid=2) by security software on Windows. Especially those that have virus-like behavior such as embedded executable resources that are extracted, and executed.

The following steps were performed on Windows, from the Developer Command Prompt installed by Visual Studio.

To [generate](https://docs.microsoft.com/en-us/windows/desktop/appxpkg/how-to-create-a-package-signing-certificate) self-signed certificate for code signing, run

```cmd
makecert.exe -n CN=Test.org(Test) -r -h 0 -eku "1.3.6.1.5.5.7.3.3,1.3.6.1.4.1.311.10.3.13" -e 12/31/2017 -pe -sv Test.pvk Test.cer
```

Here's a brief overview of the command line
-n subject name
-r create self-signed certificate
-h max height of tree below this cert
-eku comma separated enhanced key usage ids
-e expiration date
-pe private key is exportable
-sv private key file name

You may specify a password or leave it empty.

To convert self-signed certificate to PFX format for usage with SignTool, run

```cmd
Pvk2Pfx -pvk Test.pvk -spc Test.cer -pfx Test.pfx
```

To [use](https://docs.microsoft.com/windows/desktop/appxpkg/how-to-sign-a-package-using-signtool) SignTool to sign an executable, run

```cmd
SignTool sign /fd SHA256 /a /f Test.pfx filepath.exe
```

Install certificate (Test.cer) to local machine before running executable.

![Install certificate (Test.cer) to local machine](/assets/img/code-signing-root-certificate.png)

## Signing a Wix Toolset setup bundle

You cannot just sign the setup bundle executable and get it to work, because the embedded executable (engine.exe) remains unsigned and will be flagged as a security risk. Use the [following steps](http://stackoverflow.com/questions/19254772/how-do-i-use-insignia-exe-to-codesign-a-wix-bundle) to prepare setup bundle for installation without being flagged as a security risk.

First, detach the engine from setup as follows

```cmd
insignia -ib setup.exe -o engine.exe
```

Sign engine.exe with your certificate using SignTool

```cmd
SignTool sign /fd SHA256 /a /f Test.pfx engine.exe
```

Re-attach the signed engine.exe to the bundle

```cmd
insignia -ab engine.exe setup.exe -o setup.exe
```

Sign setup.exe with your certificate

```cmd
SignTool sign /fd SHA256 /a /f Test.pfx setup.exe
```