---
layout: default
title: MQTT with RabbitMQ and Node-RED
tags: mqtt rabbitmq node-red docker
comments: true
---
# MQTT with RabbitMQ and Node-RED

This post shows how to enable [MQTT](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html) in [RabbitMQ](https://www.rabbitmq.com), and use Node-RED to test the setup. Official Docker container images of both RabbitMQ and Node-RED are used for convenience.

To start RabbitMQ [Docker container](https://github.com/docker-library/docs/tree/master/rabbitmq) run

```bash
docker run -it --name myrabbitmq -p 5672:5672 -p 15672:15672 -p 1883:1883 -p 15675:15675 rabbitmq:3
```

AMQP port `5672`, management web interface port `15672`, MQTT protocol port `1883`, and WebSocket protocol port `15675` are exposed. MQTT over WebSocket can be accessed at ws://172.24.6.221:15675/ws.

If you kill the above shell and need to run the same container again

```bash
docker start -ai myrabbitmq
```

[Management web interface plugin](https://www.rabbitmq.com/management.html) and [MQTT plugin](https://www.rabbitmq.com/mqtt.html) need to be enabled next.

Start a Bash shell into the container

```bash
docker exec -it myrabbitmq /bin/bash
```

Enable the plugins by issuing the `rabbitmq-plugins` command

```bash
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_mqtt
rabbitmq-plugins enable rabbitmq_web_mqtt
rabbitmq-plugins enable rabbitmq_amqp1_0
```

Now, you should be able to log into the management interface at http://localhost:15672 using username/password guest/guest, and use MQTT from any compatible MQTT client. AMQP 1.0 plugin is also enabled in case you want to emulate a service such as Azure Service Bus.

Node-RED, a popular tool to orchestrate IoT devices, [can now be used to test MQTT]({% link _posts/2019/2019-02-15-mqtt-in-node-red-with-docker.md %}).
