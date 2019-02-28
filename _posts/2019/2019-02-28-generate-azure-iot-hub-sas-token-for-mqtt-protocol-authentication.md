---
layout: default
title: Generate Azure IoT Hub SAS token for MQTT protocol authentication
tags: mqtt azure iot
comments: true
---
# Generate Azure IoT Hub SAS token for MQTT protocol authentication

Azure IoT Hub and Azure IoT Central [support the MQTT protocol](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-mqtt-support) and require the authentication password to be a SAS token. The Node.js script below allows [generation of the SAS token](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-security#security-tokens).

```javascript
var crypto = require("crypto");

var generateSasToken = function(resourceUri, signingKey, policyName, expiresInMins) {
    resourceUri = encodeURIComponent(resourceUri);

    // Set expiration in seconds
    var expires = (Date.now() / 1000) + expiresInMins * 60;
    expires = Math.ceil(expires);
    var toSign = resourceUri + '\n' + expires;

    // Use crypto
    var hmac = crypto.createHmac('sha256', new Buffer.from(signingKey, 'base64'));
    hmac.update(toSign);
    var base64UriEncoded = encodeURIComponent(hmac.digest('base64'));

    // Construct authorization string
    var token = "SharedAccessSignature sr=" + resourceUri + "&sig="
    + base64UriEncoded + "&se=" + expires;
    if (policyName) token += "&skn="+policyName;
    return token;
};

var endpoint ="iotc-7c0a60bd-6b82-4729-94aa-5cadf2a278df.azure-devices.net/devices/c286ad6f-7892-4e0b-b785-3a4ad7085b30";
var deviceKey ="UbJvgIfQo9XNzeF8u7OGZPjT0jOZhg43X7PMnTlBzdA=";

console.log(generateSasToken(endpoint, deviceKey, null, 60));
```

Plug in `endpoint` and `deviceKey` values and execute the script.
