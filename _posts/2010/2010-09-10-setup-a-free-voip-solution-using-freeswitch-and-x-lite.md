---
layout: default
title: Setup a free VoIP solution using FreeSWITCH and X-Lite
tags:
comments: true
---

[FreeSWITCH](http://www.freeswitch.org/) is an alternative to the popular [Asterisk](http://www.asterisk.org/) VoIP solution. The advantage I see with FreeSWITCH is its ease of deployment on Windows, that is the only reason I decided to give it a quick whirl. I'll go through the steps required to [install](http://wiki.freeswitch.org/wiki/Getting_Started_Guide) FreeSWITCH and test it using the free [X-Lite](http://www.counterpath.net/x-lite.html) VoIP client from CounterPath. I tested with X-Lite version 4, which has just been released, but version 3 should also work.

Download the latest release of FreeSWITCH and install it. You can choose to run FreeSWITCH at the end of the install, do so. Otherwise, you can launch FreeSWITCH again from the Start menu. FreeSWITCH uses the Session Initiation Protocol or SIP to establish calls. It binds the SIP stack to the IP address of the default interface.  You can use TCP View from the [Sysinternals](http://technet.microsoft.com/en-us/sysinternals/default.aspx) suite to check which IP address FreeSWITCH is bound to on Port 5060 (the default SIP port).

Once you know the IP address, you can configure X-Lite to use FreeSWITCH. Download and install X-Lite. Access the Account Settings page and set the following fields

User ID: 1000

Domain: <IPv4 address>

Password: 1234

Select the OK button. If all is well X-Lite should connect with FreeSWITCH and show the presence status as Available.

FreeSWITCH has dialplans 1000-1019 configured by default. The default password is 1234. It can be changed by editing the file `conf/vars.xml` under the installation folder.

Now, you can call extension 9195 in X-Lite and speak into your microphone. Your voice should be played back to you with a delay of 5 seconds.

Enjoy your first VoIP conversation!
