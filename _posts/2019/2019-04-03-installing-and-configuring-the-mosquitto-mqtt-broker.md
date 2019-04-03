---
layout: default
title: Installing and configuring the Mosquitto MQTT broker
tags: mosquitto authentication tls mqtt
comments: true
---
# Installing and configuring the Mosquitto MQTT broker

This post contains basic instructions on installing and configuring Mosquitto MQTT broker in a Docker container and on Windows.

## Install Mosquitto

In a Docker container

```bash
docker run -it --name mosquitto1 -p 1883:1883 eclipse-mosquitto
```

To restart container later

```bash
docker start -ai mosquitto1
```

To edit config file exec command shell in container

```bash
docker exec -it mosquitto1 /bin/sh
```

Run vi

```bash
vi /mosquitto/config/mosquitto.conf
```

### Install on Windows

Download and run installer available at https://mosquitto.org/download/. See that the option to install service is checked. Configuration file `mosquitto.conf` is located at `C:\Program Files\mosquitto` by default.

## Enable Persistence

In Docker container

```conf
persistence true
persistence_file mosquitto.db
persistence_location /mosquitto/data/
```

On Windows

```conf
persistence true
persistence_file mosquitto.db
persistence_location C:/Program Files/mosquitto/
```

## Enable logging

Docker container logs to standard output.

On Windows

```conf
log_dest file C:/Program Files/mosquitto/mosquitto.log
log_type all
```

You may have to tweak file permissions to be able to view it.

## Setup TLS 1.2

TLS 1.2 can be enabled using a self-signed certificate. You can generate one using [OpenSSL or PowerShell]({% link _posts/2018/2018-01-17-create-valid-self-signed-certificates-using-openssl.md %}).

To enable TLS 1.2 for default listener

```conf
cafile C:/Program Files/mosquitto/cert.pem
certfile C:/Program Files/mosquitto/cert.pem
keyfile C:/Program Files/mosquitto/key.pem
tls_version tlsv1.2
```

## Setup username/password authentication

Create password file

```bash
mosquitto_passwd -c passwordfile user1
```

Add another user

```bash
mosquitto_passwd -c passwordfile user1
```

Disable anonymous access and specify password file

```conf
allow_anonymous false
password_file C:/Program Files/mosquitto/passwordfile
```

## Perform access control

Create aclfile

```conf
# This only affects clients with username "user1".
user user1
topic foo/bar
```

`user1` can only subscribe and publish to topic `foo/bar`.

Specify `acl_file` in configuration

```conf
acl_file C:/Program Files/mosquitto/aclfile
```

## Configure a bridge

Run another Mosquitto instance using Docker

```bash
docker run -it --name mosquitto2 -p 1884:1883 eclipse-mosquitto
```

Configure mosquitto1 container to publish/subscribe messages on any topic to mosquitto2 container, with QoS Level 1

```conf
connection mosquitto2
address 172.24.6.221:1884
topic # both 1
```

Adjust host IP address appropriately.
