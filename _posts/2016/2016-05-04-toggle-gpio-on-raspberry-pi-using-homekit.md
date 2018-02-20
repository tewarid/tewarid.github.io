---
layout: default
title: Toggle GPIO on Raspberry Pi using HomeKit
tags: homekit ios raspberry pi homebridge
---

In this post, I take my HomeKit Raspberry Pi integration a step further, by turning on/off a LED using the [homebridge-gpio-wpi](https://www.npmjs.com/package/homebridge-gpio-wpi) plugin. With the ability to control the [GPIO](https://www.raspberrypi.org/documentation/usage/gpio/) pins, I should be able to turn on/off much bigger things using [solid state relays](https://www.sparkfun.com/products/13015) and such.

## Install homebridge-gpio-wpi plugin

The installation should be pretty straightforward. Assuming you are at the command line in the home folder, run

```bash
npm install homebridge-gpio-wpi
```

That should install all node modules under `~/node_modules/`.

Configure homebridge by editing `~/.homebridge/config.json`.

Here's mine

```javascript
{
    "bridge": {
        "name": "Homebridge",
        "username": "CC:22:3D:E3:CE:32",
        "port": 51826,
        "pin": "031-45-155"
    },

    "description": "This has some fake accessories",

    "accessories": [
        {
            "accessory":      "FakeBulb",
            "name":           "Test lamp",
            "bulb_name":      "Lamp 1"
        },
        {
            "accessory": "GPIO",
            "name": "GPIO2",
            "pin": 27
        }
    ],

    "platforms": []
}
```

Configure GPIO2 using the `gpio` utility, and start homebridge

```bash
gpio -g mode 27 out
gpio -g mode 27 down
gpio export 27 out
export NODE_PATH=$HOME/node_modules/
homebridge
```

See also how to [run homebridge as a service upon reboot](https://delog.wordpress.com/2016/05/10/run-homebridge-as-a-service-upon-reboot/).

## Test with HomeKit

If you've configured the Homebridge peripheral in an iOS app such as [Hesperus](https://itunes.apple.com/us/app/hesperus/id969348892?mt=8), it should now show you a new device called GPIO2, and allow you to switch it on/off.

![LED](/assets/img/ios-homekit-hesperus-led.jpg)

Hesperus allows you to create a schedule to turn on and off devices.

![Schedule](/assets/img/ios-homekit-hesperus-schedule.jpg)
