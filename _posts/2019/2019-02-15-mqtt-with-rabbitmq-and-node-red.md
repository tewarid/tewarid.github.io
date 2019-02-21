---
layout: default
title: MQTT with RabbitMQ and Node-RED
tags: mqtt rabbitmq node-red docker
comments: true
---

This post shows how to enable [MQTT](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html) in [RabbitMQ](https://www.rabbitmq.com), and use [Node-RED](https://nodered.org) to test the setup. Official Docker container images of both RabbitMQ and Node-RED are used for convenience.

To start RabbitMQ [Docker container](https://github.com/docker-library/docs/tree/master/rabbitmq) run

```bash
docker run -it --name myrabbitmq -p 15672:15672 -p 1883:1883 -p 15675:15675 rabbitmq:3
```

Port `5672` is exposed on host by default. Management web interface port `15672`, MQTT protocol port `1883`, and WebSocket protocol port `15675` are also exposed. MQTT over WebSocket can be accessed at ws://172.24.6.221:15675/ws.

If you kill the above shell and need to run the same container again

```bash
docker start -ai myrabbitmq
```

[Management web interface plugin](https://www.rabbitmq.com/management.html) and [MQTT plugin](https://www.rabbitmq.com/mqtt.html) need to be enabled next.

Start a Bash shell into the container

```bash
docker exec -it myrabbit /bin/bash
```

Enable the plugins by issuing the `rabbitmq-plugins` command

```bash
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_mqtt
rabbitmq-plugins enable rabbitmq_web_mqtt
```

Now, you should be able to log into the management interface at http://localhost:15672 using username/password guest/guest, and use MQTT from any compatible MQTT client.

Node-RED, a popular tool to orchestrate IoT devices, can be used to test MQTT.

To run [Node-RED Docker container](https://hub.docker.com/r/nodered/node-red-docker)

```bash
docker run -it --rm -p 1880:1880 --name mynodered nodered/node-red-docker
```

If you kill the above shell and need to run the same container again

```bash
docker start -ai mynodered
```

You should now be able to create Node-RED flows at http://localhost:1880.

The first flow will be used to publish MQTT messages to RabbitMQ. Start with a new flow and add an inject node and an MQTT out node. Configure Payload in inject node to timestamp, to start after `1` second, and to repeat every `10` seconds. Configure MQTT out node next. Add new MQTT broker. Use IP address of your machine, but `localhost` or `127.0.0.1` should also do the trick. Set Port to `1883`. Finalize MQTT broker configuration. Specify Topic in MQTT out node as `nodered/test`, and QoS as `2`. Finalize node creation. Link inject node to MQTT out node.

The next flow will be used to subscribe to MQTT messages from RabbitMQ. Start with a new flow and add an MQTT in node and a debug node. Configure Server, Topic, and QoS of MQTT in node to the same values used in out node. Configure To in debug node to debug window. Link MQTT in node to debug node.

Deploy the flows. Node-RED starts publishing timestamp values to the topic you configured, at 10 second intervals, receiving the values, and showing them in the debug messages view.
