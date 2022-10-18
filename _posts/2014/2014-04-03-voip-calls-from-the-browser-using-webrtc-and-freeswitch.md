---
layout: default
title: VoIP calls from the browser using WebRTC and FreeSWITCH
tags: voi sip webrtc freeswitch
comments: true
---
# VoIP calls from the browser using WebRTC and FreeSWITCH

There was a time when making phone calls from the browser would have meant installing a native extension. Thanks to WebRTC, we can now make phone calls from the browser. This post is my recent experiment with doing exactly that, using readily available open source components.

Let's start by [installing](_posts/2010/2010-09-10-setup-a-free-voip-solution-using-freeswitch-and-x-lite.md) FreeSWITCH (FS). I am assuming a Windows based setup but Linux or Mac should also work. Once you have FS installed&mdash;I'm on version 1.5.8b+git~20131213T181356Z~87751f9eaf~64bit&mdash;and sanity-tested you'll need to enable WebSocket support. This can be done by editing the configuration file <FS folder>\conf\sip_profiles\internal.xml so the the following line is not commented

```xml
    <param name="ws-binding"  value=":5066"/>
```

You can also use secure WebSockets, but I'll leave that setup for a future exercise. At this point, restart the _FreeSWITCH_ service.

The next step is to find a suitable browser-based SIP client. Luckily, there is exactly such a [client](https://tryit.jssip.net/) provided by jsSIP, and you don't even have to install it. Fire up your browser&mdash;I'm using the latest version of Chrome&mdash;and access that URL. Assuming that your IP address is 10.211.55.3, this is the information you can provide

Name: Your Name

SIP URI: sip:1000@10.211.55.3

SIP Password: 1234

WS URI: ws://10.211.55.3:5066

Hit ENTER and you'll be taken to the dialer. You'll need to allow the browser to use your microphone. Dial 9195 to make a call, FS will relay your voice back to you after a five second delay.

[sipML5](https://www.doubango.org/sipml5/call.htm) is another nice alternative to jsSIP. You'll need to edit the WebSocket Server URL in [expert mode](https://www.doubango.org/sipml5/expert.htm).

Happy RTCing!
