---
layout: default
title: Run homebridge as a service upon reboot
tags: homebridge raspberry pi ios homekit upstart
---

This post shows how to run [homebridge](https://github.com/nfarina/homebridge/wiki/Running-HomeBridge-on-a-Raspberry-Pi) automatically upon reboot using [upstart](http://upstart.ubuntu.com/cookbook/). If you're using [systemd](https://www.freedesktop.org/wiki/Software/systemd/), the default initialization system these days, see [Running Homebridge on Bootup (systemd)](https://github.com/nfarina/homebridge/wiki/Running-HomeBridge-on-a-Raspberry-Pi#running-homebridge-on-bootup-systemd).

Install upstart

```bash
sudo apt-get install upstart
```

Create configuration file `/etc/init/homebridge.conf` with

```bash
start on stopped rc
stop on shutdown

setuid pi

script
    export HOME="/home/pi"
    export NODE_PATH=$HOME/node_modules/
    gpio -g mode 27 out
    gpio -g mode 27 down
    gpio export 27 out
    exec /usr/local/bin/homebridge
end script
```

`start on stopped rc` ensures that `avahi-daemon` has been started by its SysV init script under `/etc/init.d` before homebridge is started.

Test the job by running it thus

```bash
sudo start homebridge
```

Use the following command to check the output of the job

```bash
sudo tail -f /var/log/upstart/homebridge.log
```

The following command can be used to verify that homebridge job has been started

```bash
sudo initctl list | grep homebridge
```

To stop the above job

```bash
sudo stop homebridge
```

To run job as a service that will run automatically at boot

```bash
sudo service homebridge start
```

To stop the service forever

```bash
sudo service homebridge stop
```