---
layout: default
title: Handle custom CAs in iOS app
tags: ca ios objc openssl alamofire
comments: true
---

This post discusses how to handle custom CAs in a Swift 2 iOS app that uses [Alamofire](https://github.com/Alamofire/Alamofire).

Certificates need to be in the DER encoded binary format. If they are in PEM (BASE64) encoded text format, you need to convert them to DER encoded format. This can be achieved with openssl, thus

```bash
openssl x509 -inform PEM -in infile.cer -outform DER -out outfile.cer
```

Then, just drag the certificate files into your Xcode project so that they are embedded as resources.

Next, we need to create a custom Alamofire manager with a custom ServerTrustPolicyManager

```objc
let serverTrustPolicies: [String: ServerTrustPolicy] = [
    "example.com": .PinCertificates(
        certificates: ServerTrustPolicy.certificatesInBundle(),
        validateCertificateChain: true,
        validateHost: true
    )
]

manager = Manager(
    serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
)
```

All REST requests should then be created using manager.request instead of Alamofire.request.

In iOS 9, additional transport security exceptions are required to be set in info.plist.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<!-- ... -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSExceptionDomains</key>
        <dict>
            <key>example.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
                <key>NSIncludesSubdomains</key>
                <true/>
                <!-- Optional: Specify minimum TLS version -->
                <key>NSTemporaryExceptionMinimumTLSVersion</key>
                <string>TLSv1.2</string>
            </dict>
        </dict>
    </dict>
<!-- ... -->
</dict>
</plist>
```
