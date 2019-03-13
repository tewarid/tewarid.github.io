---
layout: default
title: MQTT and AMQP 1.0 interoperability in RabbitMQ
tags: mqtt rabbitmq amqp
comments: true
---
# MQTT 3.1.1 and AMQP 1.0 interoperability in RabbitMQ

RabbitMQ's [AMQP 1.0 plugin](https://github.com/rabbitmq/rabbitmq-amqp1.0) can be used by application to chat with devices that use the MQTT 3.1.1 protocol. You need to use the [appropriate AMQP 1.0 link address](https://github.com/rabbitmq/rabbitmq-amqp1.0#routing-and-addressing) so that RabbitMQ is able to route the messages through the `amq.topic` exchange used for the MQTT protocol.

If an MQTT publisher publishes to a topic such as `1/temperature`, the AMQP sender should use address `/topic/1.temperature`. The `/topic/` prefix indicates that the `amq.topic` exchange is used, that routes a message to all the linked receivers. This behavior is different from the default AMQP exchange, that routes a message to linked receivers in a round robin fashion, thus only one receiver picks up the message for processing.

If an MQTT subscriber subscribes to a topic such as `+/temperature`, an AMQP receiver should use address `/topic/*.temperature`. The multi-level wildcard symbol `#` may also be used. A receiver can receive all messages sent to  `amq.topic` exchange using the address `/topic/#`.
