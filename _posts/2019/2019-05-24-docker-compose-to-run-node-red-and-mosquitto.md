---
layout: default
title: Docker Compose to run Node-RED and Mosquitto
tags: docker compose mqtt node-red nodered
comments: true
---
# Docker Compose to run Node-RED and Mosquitto

Docker Compose can be very useful to bring up multiple containers that are part of a single solution, using a command such as

```bash
docker-compose -f test.yml up
```

The [compose file](https://docs.docker.com/compose/compose-file/) below shows how to configure Node-RED and Mosquitto services, to use with the command above

```yml
version: "3"
services:
  broker:
    image: eclipse-mosquitto
    volumes:
      - "./mosquitto:/mosquitto"
    networks:
      - localnet
    ports:
      - "1883:1883"
  node-red:
    depends_on:
      - broker
    image: nodered/node-red-docker
    volumes:
      - "./node-red:/data"
    user: "0"
    networks:
      - localnet
    ports:
      - "1880:1880"
networks:
  localnet:
```

Volume mapping allows all configuration and data to be stored on the host file system, or elsewhere on the network. Configuration of Node-RED is assumed to be in folder `node-red`, relative to the compose file location, and Mosquitto configuration and data is assumed to be under folder `mosquitto`.

The compose file defines a private bridge network called `localnet`. Code running in containers can use service names specified in compose file as host names. In the Node-RED container, `broker` will resolve to IP address of the container running Mosquitto.

Port mapping allows container services to be available to applications running on the host or host network. A browser running on the host can access Node-RED at `http://localhost:1880`. Another machine on the same network can access it at `http://<ip address of host>:1880`. Mosquitto can be access at port `1883` on the host network.
