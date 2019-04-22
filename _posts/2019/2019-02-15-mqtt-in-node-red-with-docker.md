---
layout: default
title: MQTT in Node-RED with Docker
tags: mqtt node-red nodered docker
comments: true
---
# MQTT in Node-RED with Docker

This post shows how to use MQTT in [Node-RED](https://nodered.org) with brokers such as RabbitMQ and Mosquitto. The official Docker container image of Node-RED is used for convenience.

To run [Node-RED Docker container](https://hub.docker.com/r/nodered/node-red-docker)

```bash
docker run -it -p 1880:1880 --name mynodered nodered/node-red-docker
```

If you kill the above shell and need to run the same container again

```bash
docker start -ai mynodered
```

You should now be able to create Node-RED flows at http://localhost:1880.

## Publish

The first flow will be used to publish MQTT messages to the broker. Start with a new flow and add an inject node and an MQTT out node. Configure Payload in inject node to timestamp, to start after `1` second, and to repeat every `10` seconds. Configure MQTT out node next. Add new MQTT broker. Assuming MQTT broker is installed on your machine, set Server to `localhost` or `127.0.0.1`. Set Port to `1883`. Specify TLS and security settings if needed and finalize MQTT broker configuration. Specify Topic in MQTT out node as `nodered/test` and QoS as `2`. Finalize node creation. Link inject node to MQTT out node.

## Subscribe

The next flow will be used to subscribe to MQTT messages at the broker. Start with a new flow and add an MQTT in node and a debug node. Configure Server, Topic, and QoS of MQTT in node to the same values used in out node. Configure To in debug node to debug window. Link MQTT in node to debug node.

## Deploy

Deploy the flows.

Node-RED starts publishing timestamp values to the topic you configured, at 10 second intervals. It will also start receiving the values and showing them in the debug messages view.
